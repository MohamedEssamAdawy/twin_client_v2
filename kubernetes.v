module twin_client_v2

import threefoldtech.info_specs_grid3.vlang.zos
import json

pub struct K8S {
pub:
	name        string
	secret      string
	masters     []Node
	workers     []Node
	network     Network
	metadata    string
	description string
	ssh_key     string
}

pub struct Node {
pub mut:
	deployment_name string
	name            string
	node_id         u32
	cpu             u32
	memory          u64
	disk_size       u32
	public_ip       bool
}

pub fn (mut tw Client) deploy_kubernetes(payload K8S) ?DeployResponse {
	/*
	Deploy kubernetes workload
		Input:
			- payload (K8S): kubernetes payload
		Output:
			- DeployResponse: new Contract instance and wireguard config.
	*/
	payload_encoded := json.encode_pretty(payload)
	return tw.deploy_kubernetes_with_encoded_payload(payload_encoded)
}

pub fn (mut tw Client) deploy_kubernetes_with_encoded_payload(payload_encoded string) ?DeployResponse {
	/*
	Deploy kubernetes workload with encoded payload
		Input:
			- payload (string): kubernetes encoded payload.
		Output:
			- DeployResponse: new Contract instance and wireguard config.
	*/
	mut msg := tw.send('twinserver.k8s.deploy', payload_encoded) ?
	response := tw.read(msg)
	return json.decode(DeployResponse, response.data) or {}
}

pub fn (mut tw Client) get_kubernetes(name string) ?[]zos.Deployment {
	/*
	Get kubernetes info using deployment name
		Input:
			- name (string): Deployment name
		Output:
			- kubernetes: kubernetes instance with all kubernetes info.
	*/
	mut msg := tw.send('twinserver.k8s.get', '{"name": "$name"}') ?
	response := tw.read(msg)
	return json.decode([]zos.Deployment, response.data) or {}
}

pub fn (mut tw Client) add_worker(deployment_name string, worker Node) ?DeployResponse {
	mut add_payload := worker
	add_payload.deployment_name = deployment_name
	payload_encoded := json.encode_pretty(add_payload)
	mut msg := tw.send('twinserver.k8s.add_worker', payload_encoded) ?
	response := tw.read(msg)
	return json.decode(DeployResponse, response.data) or {}
}

pub fn (mut tw Client) delete_worker(deployment_name string, worker_name string) ?DeployResponse {
	mut delete_payload := map[string]string{}
	delete_payload = {
		'deployment_name': deployment_name
		'name':            worker_name
	}
	payload_encoded := json.encode_pretty(delete_payload)
	// panic("Just print payload, $payload_encoded")
	mut msg := tw.send('twinserver.k8s.delete_worker', payload_encoded) ?
	response := tw.read(msg)
	return json.decode(DeployResponse, response.data) or {}
}

pub fn (mut tw Client) update_kubernetes(payload K8S) ?DeployResponse {
	/*
	Update kubernetes with payload.
		Input:
			- payload (K8S): kubernetes instance with modified data.
		Output:
			- K8S: kubernetes instance with updated info.
	*/
	payload_encoded := json.encode_pretty(payload)
	return tw.update_kubernetes_with_encoded_payload(payload_encoded)
}

pub fn (mut tw Client) update_kubernetes_with_encoded_payload(payload_encoded string) ?DeployResponse {
	/*
	Get kubernetes info using deployment name.
		Input:
			- payload_encoded (string): encoded payload with modified data.
		Output:
			- K8S: kubernetes instance with updated info.
	*/
	mut msg := tw.send('twinserver.k8s.update', payload_encoded) ?
	response := tw.read(msg)
	return json.decode(DeployResponse, response.data) or {}
}

pub fn (mut tw Client) list_kubernetes() ?[]string {
	/*
	List all kubernetes
		Output:
			- Deployments: Array of all current kubernetes.
	*/
	mut msg := tw.send('twinserver.k8s.list', '{}') ?
	response := tw.read(msg)
	return json.decode([]string, response.data) or {}
}

pub fn (mut tw Client) delete_kubernetes(name string) ?ContractDeployResponse {
	/*
	Delete deployed kubernetes.
		Input:
			- name (string): kubernetes name.
		Output:
			- contract id.
	*/
	mut msg := tw.send('twinserver.k8s.delete', '{"name": "$name"}') ?
	response := tw.read(msg)
	return json.decode(ContractDeployResponse, response.data) or {}
}
