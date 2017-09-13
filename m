From: Jan Kara <jack@suse.cz>
Subject: Re: Unexpected writes seen on a Read-only, DAX enabled EXT4 fs
Date: Wed, 13 Sep 2017 16:48:38 +0200
Message-ID: <20170913144838.GA3837@quack2.suse.cz>
References: <2036030243.251059.1504977026265.ref@mail.yahoo.com>
 <2036030243.251059.1504977026265@mail.yahoo.com>
 <20170911182112.GA20005@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Soccer Liu <soccer_liu@yahoo.com>, linux-ext4@vger.kernel.org,
        "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49703 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751734AbdIMOsk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 13 Sep 2017 10:48:40 -0400
Content-Disposition: inline
In-Reply-To: <20170911182112.GA20005@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 11-09-17 12:21:12, Ross Zwisler wrote:
> On Sat, Sep 09, 2017 at 05:10:26PM +0000, Soccer Liu wrote:
> > Hi:
> >   I was surprised to see a few write operations called into
> > ext4_dax_huge_fault with FAULT_FLAG_WRITE set on vmf->flags
> > Are those writes expected at all?
> > static int ext4_dax_huge_fault(struct vm_fault *vmf,
> >  enum page_entry_size pe_size)
> > {
> > ...
> >  bool write = vmf->flags & FAULT_FLAG_WRITE;
> > Based on the following Mount documentation below, I did mount this ext fs
> > with ro and noloadAre there any other options that I could use to totally
> > eliminate those unexpected writes?

Well, I expect these are actually 4KB faults into private mapping (they
would end up using ext4_dax_huge_fault() as well) and the fix Ross
references below should fix that... But please tell if it does not (along
with a reproducer). Thanks!

> Adding the ext4 list.
> 
> I'm pretty sure that this is ext4/mm behavior that is independent of DAX.  DAX
> doesn't really have any impact on whether or not write page faults happen on a
> RO ext4 filesystem, though this fix from Randy Dodgen:
> 
> https://www.spinics.net/lists/linux-ext4/msg58075.html
> 
> shows that FAULT_FLAG_WRITE can be set on DAX read-only ext4 mounts when
> executing binaries, though in this case the write is going to a COW page.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
