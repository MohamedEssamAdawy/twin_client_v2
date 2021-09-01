module twin_client_v2
import json

pub struct Twin {
pub:
	version u32
	id u32
	account_id string
	ip string
	entities []EntityProof
}

struct EntityProof{
	entity_id u32
	signature string
}

pub fn (mut tw Client) create_twin (ip string) ?Twin {
	/*
		Create a new twin
		Input:
			- ip: ipv6 address
		Output:
			- Twin: new twin instance with all twin info.
	*/

	mut msg := tw.send("twinserver.twins.create", '{"ip": "$ip"}') ?
	response := tw.read(msg)
	println("--------- Create Twin Response ---------")
	println(response)
	return json.decode(Twin, response.data)
}

pub fn (mut tw Client) get_twin (id u32) ?Twin {
	/*
		Get twin info using twin id
		Input:
			- id: twin id
		Output:
			- Twin: twin instance with all twin info.
	*/
	mut msg := tw.send("twinserver.twins.get", '{"id": $id}') ?
	response := tw.read(msg)
	println("--------- Get Twin Response ---------")
	// {"version":1,"id":49,"account_id":"5D2etsCt37ucdTvybV8PaeQzmoUsNp7RzxZQGJosmY8PUvKQ","ip":"201:e709:df8b:b04:6125:1ced:c211:a404","entities":[]}
	println(response)
	return json.decode(Twin, response.data)
}

pub fn (mut tw Client) list_twins () ?[]Twin {
	/*
		List all twins
		Output:
			- Twins: Array of all current twins.
	*/
	mut msg := tw.send("twinserver.twins.list", '{}') ?
	response := tw.read(msg)
	println("--------- List Twin Response ---------")
	println(response)
	return json.decode([]Twin, response.data)
}

pub fn (mut tw Client) delete_twin (id u32) ? {
	/*
		Delete twin
		Input:
			- id: twin id
	*/
	mut msg := tw.send("twinserver.twins.delete", '{"id": $id}') ?
	response := tw.read(msg)
	println("--------- Delete Twin Response ---------")
	println(response)
}