//
//  Pagination.swift
//  IndraMovie
//
//  Created by Raul on 30/12/21.
//  Copyright © 2021 Raul Quispe. All rights reserved.
//

import Foundation

/**
 Some methods are paginated. By default, 1 page of 10 items will be returned. You can send these values by adding `?page={page}&limit={limit}` to the URL.
 */
public struct Pagination {
    /// Number of page of results to be returned.
    public let page: Int
    /// Number of results to return per page.
    public let limit: Int
    
    public init(page: Int, limit: Int) {
        self.page = page
        self.limit = limit
    }
    
    public func value() -> [(key: String, value: String)] {
        return [("page", "\(self.page)"),
                ("limit", "\(self.limit)")]
    }
}
