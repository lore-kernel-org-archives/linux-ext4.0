From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 0/2] ext4: Fix ENOSPC handling for DAX faults
Date: Fri, 15 Dec 2017 12:36:25 -0700
Message-ID: <20171215193625.GA5454@linux.intel.com>
References: <20171213091352.23448-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14339 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756152AbdLOTg1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 15 Dec 2017 14:36:27 -0500
Content-Disposition: inline
In-Reply-To: <20171213091352.23448-1-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Dec 13, 2017 at 10:13:50AM +0100, Jan Kara wrote:
> Hello,
> 
> these two patches fix handling of ENOSPC during DAX faults. The problem is
> that currently running transaction may be holding lots of already freed
> blocks which can be reallocated only once the transaction commits. Standard
> retry logic in ext4_iomap_end() does not work for DAX page fault handler
> since we hold current transaction open in ext4_dax_huge_fault() and thus
> retry logic cannot force the running transaction and as a result application
> gets SIGBUS due to premature ENOSPC error.
> 
> These two patches fix the problem. I'm not too happy about patch 1/2 passing
> additional info (error code) from the fault handler but I don't see an
> easy better option since we want to also pass back special return values
> like VM_FAULT_FALLBACK. Comments are welcome.

I also don't love having two error codes coming back out of the DAX fault
handlers.  I'm worried that we'll end up forgetting to set errp in some cases,
and will only set the VM_FAULT_* error code.

I wonder if a better way to solve this would be to define a new
VM_FAULT_NOSPC, just like we have VM_FAULT_OOM for ENOMEM errors?  Essentially
what it seems like we are saying is that the very general return of just
VM_FAULT_SIGBUS doesn't provide us enough information, and that being able to
distinguish that from ENOSPC errors would be useful.

With that flag we would have 2 choices:

1) Add VM_FAULT_NOSPC to the VM_FAULT_ERROR mask, and then update things like
mm_fault_error() appropriately so, like the other errors in this class, it
results in SIGBUS, or

2) Just always return (VM_FAULT_NOSPC|VM_FAULT_SIGBUS), which I think would
mean that you wouldn't need to alter mm_fault_error() et al.

Do either of these sound appealing?
