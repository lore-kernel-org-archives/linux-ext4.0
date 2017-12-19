From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 0/2] ext4: Fix ENOSPC handling for DAX faults
Date: Tue, 19 Dec 2017 15:30:51 +0100
Message-ID: <20171219143051.GA25754@quack2.suse.cz>
References: <20171213091352.23448-1-jack@suse.cz>
 <20171215193625.GA5454@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        Ted Tso <tytso@mit.edu>,
        Dan Williams <dan.j.williams@intel.com>,
        linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171215193625.GA5454@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri 15-12-17 12:36:25, Ross Zwisler wrote:
> On Wed, Dec 13, 2017 at 10:13:50AM +0100, Jan Kara wrote:
> > Hello,
> > 
> > these two patches fix handling of ENOSPC during DAX faults. The problem is
> > that currently running transaction may be holding lots of already freed
> > blocks which can be reallocated only once the transaction commits. Standard
> > retry logic in ext4_iomap_end() does not work for DAX page fault handler
> > since we hold current transaction open in ext4_dax_huge_fault() and thus
> > retry logic cannot force the running transaction and as a result application
> > gets SIGBUS due to premature ENOSPC error.
> > 
> > These two patches fix the problem. I'm not too happy about patch 1/2 passing
> > additional info (error code) from the fault handler but I don't see an
> > easy better option since we want to also pass back special return values
> > like VM_FAULT_FALLBACK. Comments are welcome.
> 
> I also don't love having two error codes coming back out of the DAX fault
> handlers.  I'm worried that we'll end up forgetting to set errp in some cases,
> and will only set the VM_FAULT_* error code.
> 
> I wonder if a better way to solve this would be to define a new
> VM_FAULT_NOSPC, just like we have VM_FAULT_OOM for ENOMEM errors?  Essentially
> what it seems like we are saying is that the very general return of just
> VM_FAULT_SIGBUS doesn't provide us enough information, and that being able to
> distinguish that from ENOSPC errors would be useful.

Yes, we need to propagate more information than just VM_FAULT_SIGBUS from
->iomap_begin() down into the page fault handler.

> With that flag we would have 2 choices:
> 
> 1) Add VM_FAULT_NOSPC to the VM_FAULT_ERROR mask, and then update things like
> mm_fault_error() appropriately so, like the other errors in this class, it
> results in SIGBUS, or
> 
> 2) Just always return (VM_FAULT_NOSPC|VM_FAULT_SIGBUS), which I think would
> mean that you wouldn't need to alter mm_fault_error() et al.
> 
> Do either of these sound appealing?

What I don't like about VM_FAULT_NOSPC is that it is polluting generic
VM_FAULT_ namespace for something that just needs to be propagated from one
ext4 function to another through the DAX helper function. In particular
generic MM has nothing to do with such error.

If forgetting to set *errp is your only concern, I think I can address that
by making the argument there 'int *iomap_ret' and storing there return from
->iomap_begin() unconditionally. That will work for ext4 as well and we
won't forget to set it. Thoughts?

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
