From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/2] dax: Pass detailed error code from dax_iomap_fault()
Date: Thu, 21 Dec 2017 10:16:44 -0700
Message-ID: <20171221171644.GB2158@linux.intel.com>
References: <20171221163055.3943-1-jack@suse.cz>
 <20171221163055.3943-2-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:10668 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751838AbdLURQq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 21 Dec 2017 12:16:46 -0500
Content-Disposition: inline
In-Reply-To: <20171221163055.3943-2-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Dec 21, 2017 at 05:30:54PM +0100, Jan Kara wrote:
> Ext4 needs to pass through error from its iomap handler to the page
> fault handler so that it can properly detect ENOSPC and force
> transaction commit and retry the fault (and block allocation). Add
> argument to dax_iomap_fault() for passing such error.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>

I like how much simpler this version is.  Looks good.

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
