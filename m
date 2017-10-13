From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 17/19] ext4: Add support for MAP_SYNC flag
Date: Fri, 13 Oct 2017 00:21:23 -0700
Message-ID: <20171013072123.GF9105@infradead.org>
References: <20171011200603.27442-1-jack@suse.cz>
 <20171011200603.27442-18-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Ted Tso <tytso@mit.edu>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:57853 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751901AbdJMHVX (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 13 Oct 2017 03:21:23 -0400
Content-Disposition: inline
In-Reply-To: <20171011200603.27442-18-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This really should be part of the previous patch.
