From: Jan Kara <jack@suse.cz>
Subject: Re: Delayed allocation and page_lock vs transaction start ordering
Date: Wed, 16 Apr 2008 11:38:03 +0200
Message-ID: <20080416093803.GB6116@duck.suse.cz>
References: <20080415161430.GC28699@duck.suse.cz> <1208282932.3636.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, sandeen@redhat.com
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:57393 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755788AbYDPJiE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Apr 2008 05:38:04 -0400
Content-Disposition: inline
In-Reply-To: <1208282932.3636.9.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 15-04-08 11:08:52, Mingming Cao wrote:
> On Tue, 2008-04-15 at 18:14 +0200, Jan Kara wrote:
> >   Hi,
> > 
> >   I've ported my patch inversing locking ordering of page_lock and
> > transaction start to ext4 (on top of ext4 patch queue). Everything except
> > delayed allocation is converted (the patch is below for interested
> > readers). The question is how to proceed with delayed allocation. Its
> > current implementation in VFS is designed to work well with the old
> > ordering (page lock first, then start a transaction). We could bend it to
> > work with the new locking ordering but I really see no point since ext4 is
> > the only user. 
> 
> I think the plan is port the changes to ext2/3/JFS and support delayed
> allocation on those filesystems. 
  I see. But ext2 doesn't care because is has no transactions, ext3 will
have exactly the same problems as ext4. I don't know about JFS but I guess
it is worth making life more complicated for JFS when it would be simpler
for ext3, ext4 and we could merge the code with XFS...

> > Also XFS has AFAIK ordering first start transaction, then
> > lock pages so if we should ever merge delayed alloc implementations the new
> > ordering would make it easier.
> >   So what do people think here? Do you agree with reimplementing current
> > mpage_da_... functions?
> 
> It worth a try, but I could not see how to bend delayed allocation to
> work the new ordering:( With delayed allocation Ext4 gets into
> writepage() directly with page locked, but we need to start transaction
> to do block allocation...:(
  I see you've already resolved these ;).

> I guess this reserve locking ordering allows support writepages() for
> ext3/4? What other the benefits?
  Yes, that is one advantage. The other one (which I care about the most)
is that transaction commit code can take page_lock in the new locking order
which is necessary for the new ordered mode rewrite.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
