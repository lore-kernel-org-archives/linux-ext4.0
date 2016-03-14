From: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Subject: RE: ext4 out of order when use cfq scheduler
Date: Mon, 14 Mar 2016 02:43:03 +0000
Message-ID: <ec4578ecc2c94f69b43f637028502073@SGPMBX1004.APAC.bosch.com>
References: <697280a570654ae0aa1723fb7d11f51e@SGPMBX1004.APAC.bosch.com>
 <20151222150037.GB18178@quack.suse.cz>
 <c67f356b63d94d35ad010a6e987b68f0@SGPMBX1004.APAC.bosch.com>
 <20160105153050.GF14464@quack.suse.cz>
 <c73ca48af09742318189c61d167c4459@SGPMBX1004.APAC.bosch.com>
 <20160106100621.GA24046@quack.suse.cz>
 <3ab48fa47e434455b101251730e69bd2@SGPMBX1004.APAC.bosch.com>
 <20160107102420.GB8380@quack.suse.cz>
 <f0c925079bb4450380c019a7455a2537@SGPMBX1004.APAC.bosch.com>
 <20160107114736.GC8380@quack.suse.cz> <20160313042723.GC29218@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Li, Michael" <huayil@qti.qualcomm.com>
To: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp6-v.fe.bosch.de ([139.15.237.11]:57947 "EHLO
	smtp6-v.fe.bosch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbcCNCnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 13 Mar 2016 22:43:07 -0400
In-Reply-To: <20160313042723.GC29218@thunk.org>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



> -----Original Message-----
> From: Theodore Ts'o [mailto:tytso@mit.edu]
> Sent: Sunday, March 13, 2016 12:27 PM
> To: Jan Kara <jack@suse.cz>
> Cc: HUANG Weller (CM/ESW12-CN) <Weller.Huang@cn.bosch.com>; linux-
> ext4@vger.kernel.org; Li, Michael <huayil@qti.qualcomm.com>
> Subject: Re: ext4 out of order when use cfq scheduler
> 
> On Thu, Jan 07, 2016 at 12:47:36PM +0100, Jan Kara wrote:
> >
> > The problem is in all kernels starting with 3.8. Attached is a patch
> > which should fix the issue. Can you test whether it fixes the problem for you?
> 
> Sorry, I missed this patch because it was attached to an discussion thread.
> 
> > The problem is that although for delayed allocated blocks we write
> > their contents immediately after allocating them, there is no
> > guarantee that the IO scheduler or device doesn't reorder things
> 
> I don't think that's the problem.  In the commit thread when we call
> blkdev_issue_flush() that acts as a barrier so the I/O scheduler won't reorder writes
> after that point, which is before we write the commit block.  Instead, I believe the
> problem is in ext4_writepages:
> 
> 		ext4_journal_stop(handle);
> 		/* Submit prepared bio */
> 		ext4_io_submit(&mpd.io_submit);
> 
> Once we release the handle, the commit can start --- *before* we have
> a chance to submit the I/O.   Oops.
> 
> I believe if we swap these two calls, it should fix the problem Huang was seeing.
> 
> Jan, do you agree?
> 
> 					- Ted

Hi Ted and Jan,

You can give me a patch and I can redo the verification on my kernel and HWs.

I also look into the code, since In my test case, I use data=ordered option and without sync.  So the write operation will goto ext4_da_writepages(), right ?
My kernel version is 3.10.63, as I see io_submit and journal_stop sequence  already in that order. 

while (!ret && wbc->nr_to_write > 0) {
ext4_journal_start
write_cache_pages_da
mpage_da_map_and_submit  ==>
ext4_journal_stop
}

Thanks.
