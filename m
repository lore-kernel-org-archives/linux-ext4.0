From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] e2fsprogs: Limit number of reserved gdt blocks on
 small fs
Date: Wed, 29 Apr 2015 12:10:25 +0200
Message-ID: <20150429101025.GB32439@quack.suse.cz>
References: <1427280382-31120-1-git-send-email-lczerner@redhat.com>
 <553ABAF0.2020702@redhat.com>
 <D2BC34F2-AB5D-4923-A2D6-28CEC2807C9A@dilger.ca>
 <20150427161451.GA22448@quack.suse.cz>
 <553E6277.3040800@redhat.com>
 <20150428122102.GA9955@quack.suse.cz>
 <alpine.LFD.2.00.1504281423330.2386@localhost.localdomain>
 <553FAB44.9050009@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="azLHFNyN32YCQGCU"
Content-Transfer-Encoding: 8bit
Cc: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>,
	Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47427 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752938AbbD2KKb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 29 Apr 2015 06:10:31 -0400
Content-Disposition: inline
In-Reply-To: <553FAB44.9050009@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--azLHFNyN32YCQGCU
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue 28-04-15 10:46:12, Eric Sandeen wrote:
> On 4/28/15 7:24 AM, Lukáš Czerner wrote:
> > On Tue, 28 Apr 2015, Jan Kara wrote:
> > 
> >> Date: Tue, 28 Apr 2015 14:21:02 +0200
> >> From: Jan Kara <jack@suse.cz>
> >> To: Eric Sandeen <sandeen@redhat.com>
> >> Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@dilger.ca>,
> >>     Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
> >> Subject: Re: [PATCH v2] e2fsprogs: Limit number of reserved gdt blocks on
> >>     small fs
> >>
> >> On Mon 27-04-15 11:23:19, Eric Sandeen wrote:
> >>> On 4/27/15 11:14 AM, Jan Kara wrote:
> >>>> On Fri 24-04-15 22:25:06, Andreas Dilger wrote:
> >>>>> On Apr 24, 2015, at 3:51 PM, Eric Sandeen <sandeen@redhat.com> wrote:
> >>>>>> On 3/25/15 5:46 AM, Lukas Czerner wrote:
> >>>>>>> Currently we're unable to online resize very small (smaller than 32 MB)
> >>>>>>> file systems with 1k block size because there is not enough space in the
> >>>>>>> journal to put all the reserved gdt blocks.
> >>>>>>
> >>>>>> So, I'll get to the patch review if I need to, but this all seemed a little
> >>>>>> odd; this is a regression, so do we really need to restrict things at mkfs
> >>>>>> time?
> >>>>>>
> >>>>>> On the userspace side, things were ok until:
> >>>>>>
> >>>>>> 9f6ba88 resize2fs: add support for new in-kernel online resize ioctl
> >>>>>>
> >>>>>> and even with that, on the kernelspace side, things were ok until:
> >>>>>>
> >>>>>> 8f7d89f jbd2: transaction reservation support
> >>>>>>
> >>>>>> I guess I'm trying to understand why that jbd2 commit regressed this.
> >>>>>> I've not been paying enough attention to ext4 lately.  ;)
> >>>>>>
> >>>>>> I mean, the threshold got chopped in half:
> >>>>>>
> >>>>>> -       if (nblocks > journal->j_max_transaction_buffers) {
> >>>>>> +       /*
> >>>>>> +        * 1/2 of transaction can be reserved so we can practically handle
> >>>>>> +        * only 1/2 of maximum transaction size per operation
> >>>>>> +        */
> >>>>>> +       if (WARN_ON(blocks > journal->j_max_transaction_buffers / 2)) {
> >>>>>>                printk(KERN_ERR "JBD2: %s wants too many credits (%d > %d)\n",
> >>>>>> -                      current->comm, nblocks,
> >>>>>> -                      journal->j_max_transaction_buffers);
> >>>>>> +                      current->comm, blocks,
> >>>>>> +                      journal->j_max_transaction_buffers / 2);
> >>>>>>                return -ENOSPC;
> >>>>>>        }
> >>>>>>
> >>>>>> so it's clear why the behavior changed, I guess, but it feels like I
> >>>>>> must be missing something here.
> >>>>>
> >>>>> Is there some way to reserve these journal blocks only in the case of
> >>>>> delalloc usage?  This has caused a performance regression with Lustre
> >>>>> servers on 3.10 kernels because the journal commits twice as often.
> >>>>> We've worked around this for now by doubling the journal size, but it
> >>>>> seems a bit of a hack since we can never use the whole journal anymore.
> >>>>   Hum, so the above hunk only limits maximum number of credits used by a
> >>>> single handle. Multiple handles can still consume upto maximum transaction
> >>>> size buffers (at least that's the intention :). So I don't see how that can
> >>>> cause the problem you describe.  What can happen though is that there are
> >>>> quite a few outstanding reserved handles and so we have to reserve space
> >>>> for them in the running transaction. Do you use dioread_nolock option? That
> >>>> enables the use of reserved handles in ext4 for conversion of unwritten
> >>>> extents...
> >>>
> >>> You're probably asking Andreas, but just in case, for my testcase, it's
> >>> all defaults & standard options.
> >>>
> >>> i.e. just this fails, after the above commit, whereas it worked before.
> >>>
> >>> mkfs.ext4 /dev/sda 20M
> >>> mount /dev/sda /mnt/test
> >>> resize2fs /dev/sda 200M
> >>   Yeah, I understand your failure - transaction reservation has reduced
> >> max transaction size to a half. After that your fs resize exceeds max
> >> transaction size and we are in trouble. I'd prefer solution for that to be
> >> in resize code though because it's really a corner case and I wouldn't like
> >> to slow down the common transaction start path for it...
> > 
> > Hi Jan,
> > 
> > if you have not already, please see the patch which started the
> > discussion.
> 
> It just doesn't feel right to me to place limits on fs geometry for this
> reason.  We could, but it seems like a stopgap.  Can we modify the
> resize code so that it doesn't need such a large transaction?
> 
> In the "old" resize world, I think we played tricks with restarting
> transactions, because until the resize was complete and superblocks were
> updated, it was ok if we lost updates to new block groups (or something
> like that...) i.e. we didn't need one giant atomic update of the filesystem.
> 
> Maybe we can do something similar here?  I've kind of lost track
> of how resize is working now, TBH.
  Well, the fact is we have to limit some fs parameters so that code can be
reasonably simple. IMO already supporting 20 MB filesystem with a journal
is a stretch and choice of number of reserved blocks looks arbitrary but
I guess we shouldn't regress if possible.

So 20 MB filesystem will get 1 MB journal. That means
j_max_transaction_size 256 and thus we allow at most 128 credits in a single
handle. The filesystem has 79 reserved GDT blocks and flex group size 16 so
when resizing to 200 MB when adding full flex group, the resize code in
ext4_flex_group_add() wants a handle with 4*16 + 79 credits which is too
much (143).

That being said the calculation in ext4_flex_group_add() looks too
pessimistic (in the flex_gd->count * 4 part). Sure we need to modify resize
inode and its dindirect block but that's common for all the groups,
similarly for superblock so we can change that to (3 + flex_gd->count) and
even that is too pessimistic since we have EXT4_DESC_PER_BLOCK(sb)
descriptors in one block. So we could shrink it to (3 + 1 + (flex_gd->count +
EXT4_DESC_PER_BLOCK(sb) - 1) / EXT4_DESC_PER_BLOCK(sb)). That will shrink
the total credit estimate down to 84 for that filesystem.

The attached patch fixes the issue for me. Thoughts?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--azLHFNyN32YCQGCU
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-ext4-Fix-growing-of-tiny-filesystems.patch"

>From 37ecb96f1ab1e57bc5c1663c1662d658df2f84fd Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Wed, 29 Apr 2015 11:46:31 +0200
Subject: [PATCH] ext4: Fix growing of tiny filesystems

The estimate of necessary transaction credits in ext4_flex_group_add()
is too pessimistic. It reserves credit for sb, resize inode, and resize
inode dindirect block for each group added in a flex group although they
are always the same block and thus it is enough to account them only
once. Also the number of modified GDT block is overestimated since we
fit EXT4_DESC_PER_BLOCK(sb) descriptors in one block.

Make the estimation more precise. That reduces number of requested
credits enough that we can grow 20 MB filesystem (which has 1 MB
journal, 79 reserved GDT blocks, and flex group size 16 by default).

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/resize.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 8a8ec6293b19..15b4b3605859 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1432,12 +1432,15 @@ static int ext4_flex_group_add(struct super_block *sb,
 		goto exit;
 	/*
 	 * We will always be modifying at least the superblock and  GDT
-	 * block.  If we are adding a group past the last current GDT block,
+	 * blocks.  If we are adding a group past the last current GDT block,
 	 * we will also modify the inode and the dindirect block.  If we
 	 * are adding a group with superblock/GDT backups  we will also
 	 * modify each of the reserved GDT dindirect blocks.
 	 */
-	credit = flex_gd->count * 4 + reserved_gdb;
+	credit = 3;	/* sb, resize inode, resize inode dindirect */
+	credit += 1 + (flex_gd->count + EXT4_DESC_PER_BLOCK(sb) - 1) /
+			EXT4_DESC_PER_BLOCK(sb);	/* GDT blocks */
+	credit += reserved_gdb;	/* Reserved GDT dindirect blocks */
 	handle = ext4_journal_start_sb(sb, EXT4_HT_RESIZE, credit);
 	if (IS_ERR(handle)) {
 		err = PTR_ERR(handle);
-- 
2.1.4


--azLHFNyN32YCQGCU--
