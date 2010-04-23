From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH 2/2] Add batched discard support for ext4.
Date: Fri, 23 Apr 2010 10:23:20 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1004230944070.2814@localhost>
References: <1271674527-2977-1-git-send-email-lczerner@redhat.com>  <1271674527-2977-2-git-send-email-lczerner@redhat.com>  <1271674527-2977-3-git-send-email-lczerner@redhat.com>  <r2k87f94c371004201421se796c0ekbae28495e62a9eb7@mail.gmail.com>
 <4BCE6243.5010209@teksavvy.com> <4BCE66C5.3060906@redhat.com>  <v2w87f94c371004211159ue3a48923u6a543e8090dcdfa6@mail.gmail.com>  <4BCF4C53.3010608@redhat.com>  <x49zl0w1uhh.fsf@segfault.boston.devel.redhat.com>
 <k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1986379648-1272011004=:2814"
Cc: Jeff Moyer <jmoyer@redhat.com>, Ric Wheeler <rwheeler@redhat.com>,
	Eric Sandeen <sandeen@redhat.com>,
	Mark Lord <kernel@teksavvy.com>,
	Lukas Czerner <lczerner@redhat.com>,
	linux-ext4@vger.kernel.org, Edward Shishkin <eshishki@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Christoph Hellwig <hch@infradead.org>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093Ab0DWIX0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Apr 2010 04:23:26 -0400
In-Reply-To: <k2y87f94c371004211344xfd17387fwc62432d022145376@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1986379648-1272011004=:2814
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 21 Apr 2010, Greg Freemyer wrote:

> >>>>> Mmm.. If that's what it is doing, then this patch set would be a
> >>>>> complete disaster.
> >>>>> It would take *hours* to do the initial TRIM.
> >
> > Except it doesn't.  Lukas did provide numbers in his original email.
> >
> 
> Looking at the benchmarks (for the first time) at
> http://people.redhat.com/jmoyer/discard/ext4_batched_discard/
> 
> I don't see anything that says how long the proposed trim ioctl takes
> to complete on the full filesystem.

Well, it strongly depends on how is the file system fragmented. On the
fresh file system (147G) the initial ioctl takes 2 seconds to finish (it 
may be worth to mention that on another SSD (111G) it takes 56s). I will
try to get some numbers for the "usual" file system (not full, not
fresh).

> 
> What they do show is that with the 3 test SSDs used for this
> benchmark, the current released discard implementation is a net loss.
> ie. You are better off running without the discards for all 3 vendors.
>  (at least under the conditions tested.)
> 
> After the patch is applied and optimizing the discards to large free
> extents only, it works out to same performance with or without the
> discards.  ie. no net gain or loss.
> 
> That is extremely cool because one assumes that the non-discard case
> would degrade over time, but that the discard case will not.
> 
> So that argues for the current proposed patch going in.
> 
> But quoting from the first email:
> 
> ==
> The basic idea behind my discard support is to create an ioctl which
> walks through all the free extents in each allocating group and discard
> those extents. As an addition to improve its performance one can specify
> minimum free extent length, so ioctl will not bother with shorter extents.
> 
> This of course means, that with each invocation the ioctl must walk
> through whole file system, checking and discarding free extents, which
> is not very efficient. The best way to avoid this is to keep track of
> deleted (freed) blocks. Then the ioctl have to trim just those free
> extents which were recently freed.
> 
> In order to implement this I have added new bitmap into ext4_group_info
> (bb_bitmap_deleted) which stores recently freed blocks. The ioctl then
> walk through bb_bitmap_deleted, compare deleted extents with free
> extents trim them and then removes it from the bb_bitmap_deleted.
> 
> But you may notice, that there is one problem. bb_bitmap_deleted does
> not survive umount. To bypass the problem the first ioctl call have to
> walk through whole file system trimming all free extents. But there is a
> better solution to this problem. The bb_bitmap_deleted can be stored on
> disk an can be restored in mount time along with other bitmaps, but I
> think it is a quite big change and should be discussed further.
> ==
> 
> The above seems to argue against the patch going in until the
> mount/umount issues are addressed.

I do not know much about how production system is being used, but I
doubt this is that big issue. Sure the initial ioctl takes long to
finish and there is a place for improvement, there was a proposal to
do the initial trim at mount time. I do not think that it is wise,
why to block mount, when the trim can be run at background when the fs
is mounted ? Of course there will be some performance loss, while ioctl
will be in progress, but it will not block.

There are also another way to overcome this problem. We can assure that
the file system is left trimmed after umount. To do this, we can simply
trim the fs at umount time. I think this won't be any problem and we even
do not prolong the umount time too much, because we will not trim whole
fs, but just recently freed blocks.

This of course bring another problem, when the system is not properly
terminated and the umount is not properly finished (or done at all). But
this can be solved in fsck at boot time I think. This will entirely
eliminate the need to trim the whole fs (except the fsck obviously),
since it is done when fs is created.

> 
> So in addition to this patch, Lukas is proposing a on disk change to
> address the fact that calling trim upteen times at mount time is too
> slow.
> 
> Per Mark's testing of last summer, an alternative solution is to use a
> vectored trim approach that is far more efficient.

Vectored trim will be great, I did not tested anything like that but
obviously it will strongly reduce time needed to trim the fs. But we do
not have this support just yet.

> 
> Mark's benchmarks showed this as doable in seconds which seems like a
> reasonable amount of time for a mount time operation.
> 
> Greg
> 


And also, currently I am rewriting the patch do use rbtree instead of the
bitmap, because there were some concerns of memory consumption. It is a
question whether or not the rbtree will be more memory friendly.
Generally I think that in most "normal" cases it will, but there are some
extreme scenarios, where the rbtree will be much worse. Any comment on
this ?


Thanks.
-Lukas
--8323328-1986379648-1272011004=:2814--
