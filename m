From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 out of order when use cfq scheduler
Date: Mon, 11 Jan 2016 11:21:00 +0100
Message-ID: <20160111102100.GA6262@quack.suse.cz>
References: <20151222150037.GB18178@quack.suse.cz>
 <c67f356b63d94d35ad010a6e987b68f0@SGPMBX1004.APAC.bosch.com>
 <20160105153050.GF14464@quack.suse.cz>
 <c73ca48af09742318189c61d167c4459@SGPMBX1004.APAC.bosch.com>
 <20160106100621.GA24046@quack.suse.cz>
 <3ab48fa47e434455b101251730e69bd2@SGPMBX1004.APAC.bosch.com>
 <20160107102420.GB8380@quack.suse.cz>
 <f0c925079bb4450380c019a7455a2537@SGPMBX1004.APAC.bosch.com>
 <20160107114736.GC8380@quack.suse.cz>
 <97be88d3acae4317ba1b6443f859ada0@SGPMBX1004.APAC.bosch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Li, Michael" <huayil@qti.qualcomm.com>
To: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55253 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758191AbcAKKUv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Jan 2016 05:20:51 -0500
Content-Disposition: inline
In-Reply-To: <97be88d3acae4317ba1b6443f859ada0@SGPMBX1004.APAC.bosch.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 11-01-16 09:05:20, HUANG Weller (CM/ESW12-CN) wrote:
> 
> > -----Original Message-----
> > From: HUANG Weller (CM/ESW12-CN)
> > Sent: Friday, January 08, 2016 8:47 AM
> > To: 'Jan Kara' <jack@suse.cz>
> > Cc: linux-ext4@vger.kernel.org; Li, Michael <huayil@qti.qualcomm.com>
> > Subject: RE: ext4 out of order when use cfq scheduler
> > 
> > > >
> > > > >
> > > > > OK, so I was looking into the code and indeed, reality is correct
> > > > > and my mental model was wrong! ;) I thought that inode gets added
> > > > > to the list of inodes for which we need to wait for data IO
> > > > > completion during transaction commit during block allocation. And I was
> > wrong.
> > > > > It used to happen in
> > > > > mpage_da_map_and_submit() until commit f3b59291a69d (ext4: remove
> > > > > calls to
> > > > > ext4_jbd2_file_inode() from delalloc write path) where it got
> > > > > removed. And that was wrong because although we submit data writes
> > > > > before dropping handle for allocating transaction and updating
> > > > > i_size, nobody guarantees that data IO is not delayed in the block
> > > > > layer until
> > > transaction commit.
> > > > > Which seems to happen in your case. I'll send a fix. Thanks for
> > > > > your report and persistence!
> > > > >
> > > >
> > > > Thanks a lot for your feedback :-)
> > > > Because I am not familiar with the detail of the ext4 internal code.
> > > > I will try to
> > > understand your explanation which you describe above.  And have a look
> > > on related funcations.
> > > > Could you send the fix in this mail ?
> > > > And whether the kernel 3.14 also have such issue, right ?
> > >
> > > The problem is in all kernels starting with 3.8. Attached is a patch
> > > which should fix the issue. Can you test whether it fixes the problem for you?
> > >
> > > 								Honza
> > > --
> > 
> > Yes, of course I will redo the test with the patch. And also give you feedback.
> 
> Test result:
> Test on 2 targets with the kernel applied your patch. Both of them are OK
> after 5000 power failure tests. Our target test cycle is 10,000.  By the
> way, since your original patch can't be applied on 3.x kernel, The
> attached one  is based on yours and can applied on old kernel(mine is
> 3.10) directly.

Thanks for testing and the port! Once the patch is merged upstream, I'll
backport it and push it to all active stable kernels.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
