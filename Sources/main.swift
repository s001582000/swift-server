//
//  main.swift
//  PerfectTemplate
//
//  Created by Kyle Jessup on 2015-11-05.
//	Copyright (C) 2015 PerfectlySoft, Inc.
//
//===----------------------------------------------------------------------===//
//
// This source file is part of the Perfect.org open source project
//
// Copyright (c) 2015 - 2016 PerfectlySoft Inc. and the Perfect project authors
// Licensed under Apache License v2.0
//
// See http://perfect.org/licensing.html for license information
//
//===----------------------------------------------------------------------===//
//

import PerfectLib
import PerfectHTTP
import PerfectHTTPServer

// An example request handler.
// This 'handler' function can be referenced directly in the configuration below.
var money = ""
func getApi(data: [String:Any]) throws -> RequestHandler {
    return {
        request, response in
        let dic = request.queryParams.last
        let (_,value) = dic!
        money = value
        // Respond with a simple message.
//        mothy = data["money"] as! Int
        response.setHeader(.contentType, value: "text/html")
        response.appendBody(string: "{\"name\":\"小軒\"}")
        // Ensure that response.completed() is called when your processing is done.
        response.completed()
    }
}

func getMoney(data: [String:Any]) throws -> RequestHandler {
    return {
        request, response in
        // Respond with a simple message.
        
        response.setHeader(.contentType, value: "text/html")
        response.appendBody(string: "{\"money\":\"\(money)\"}")
        // Ensure that response.completed() is called when your processing is done.
        response.completed()
    }
}


func handler(data: [String:Any]) throws -> RequestHandler {
    return {
        request, response in
        // Respond with a simple message.
        response.setHeader(.contentType, value: "text/html")
        response.appendBody(string: "<html><title>Hello, world!</title><body>Hello, world!我是小軒</body></html>")
        // Ensure that response.completed() is called when your processing is done.
        response.completed()
    }
}
// Configuration data for two example servers.
// This example configuration shows how to launch one or more servers 
// using a configuration dictionary.

let port1 = 4002, port2 = 4003


let confData = [
	"servers": [
		// Configuration data for one server which:
		//	* Serves the hello world message at <host>:<port>/
		//	* Serves static files out of the "./webroot"
		//		directory (which must be located in the current working directory).
		//	* Performs content compression on outgoing data when appropriate.
		[
			"name":"localhost",
			"port":8181,
			"routes":[
				["method":"get", "uri":"/", "handler":handler],
				["method":"get", "uri":"/getAgi", "handler":getApi],
				["method":"get", "uri":"/getMoney", "handler":getMoney],
				["method":"get", "uri":"/**", "handler":PerfectHTTPServer.HTTPHandler.staticFiles,
				 "documentRoot":"./webroot",
				 "allowResponseFilters":true]
			],
			"filters":[
				[
				"type":"response",
				"priority":"high",
				"name":PerfectHTTPServer.HTTPFilter.contentCompression,
				]
			]
		]
	]
]

do {
	// Launch the servers based on the configuration data.
	try HTTPServer.launch(configurationData: confData)
} catch {
	fatalError("\(error)") // fatal error launching one of the servers
}

