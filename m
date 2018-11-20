Return-Path: <SRS0=dvF+=N7=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45840 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726460AbeKUFed (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Nov 2018 00:34:33 -0500
Received: by mail-qt1-f195.google.com with SMTP id e5so1213640qtr.12
        for <linux-ext4@vger.kernel.org>; Tue, 20 Nov 2018 11:03:53 -0800 (PST)
MIME-Version: 1.0
References: <e3074993-0810-1954-7204-38b6d0b0f1e5@linux.alibaba.com> <20181120100533.GD8842@quack2.suse.cz>
In-Reply-To: <20181120100533.GD8842@quack2.suse.cz>
From: Liu Bo <obuil.liubo@gmail.com>
Date: Tue, 20 Nov 2018 11:03:41 -0800
Message-ID: <CANQeFDDAV+s5M9W8Y_VvQLOYaAjKM+J5f07HS_JUHuN0SqutWA@mail.gmail.com>
Subject: Re: ext4: try to improve unwritten extents merges
To: Jan Kara <jack@suse.cz>
Cc: xiaoguang.wang@linux.alibaba.com, darrick.wong@oracle.com,
        linux-ext4@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Jan,

(Cc linux-ext4...)

On Tue, Nov 20, 2018 at 2:07 AM Jan Kara <jack@suse.cz> wrote:
>
> Hello!
>
> On Tue 20-11-18 17:01:25, Xiaoguang Wang wrote:
> > First sorry to bother you again, recently we meet a
> > "dioread_nolock,nodelalloc" slow writeback issue, Liu Bo has sent a patch to
> > fix this issue. But here I also wonder whether we can merge unwritten
> > extents as far as possible.
> > In current codes:
> >
> > int
> > ext4_can_extents_be_merged(struct inode *inode, struct ext4_extent *ex1,
> >                               struct ext4_extent *ex2)
> > {
> > ...
> >       if (ext4_ext_is_unwritten(ex1) &&
> >           (ext4_test_inode_state(inode, EXT4_STATE_DIO_UNWRITTEN) ||
> >            atomic_read(&EXT4_I(inode)->i_unwritten) ||
> >            (ext1_ee_len + ext2_ee_len > EXT_UNWRITTEN_MAX_LEN)))
> >               return 0;
> > ...
> > }
> > This was added by Darrick in 2014:
> > commit a9b8241594adda0a7a4fb3b87bf29d2dff0d997d
> > Author: Darrick J. Wong <darrick.wong@oracle.com>
> > Date:   Thu Feb 20 21:17:35 2014 -0500
> >
> >     ext4: merge uninitialized extents
> >
> >     Allow for merging uninitialized extents.
> >
> >     Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> >     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> >
> > So long as we have a unwritten extents under io(which also means i_unwritten
> > is not zero), then we can not do merge work for unwritten extents, I wonder
> > whether this conditon is too strict. Assume that the
> > begin of the file is under io, but middle or end of the file could not
> > merge unwritten extetns, though they could be.
> >
> > I'm not sure whether we could directly remove
> > "atomic_read(&EXT4_I(inode)->i_unwritten)",if not, here I make a simple
> > patch to respect same semantics. The idea is simple, I use a red-black
> > tree to record unwritten extents under io, when trying to merging
> > unwritten extents, we search this per-inode tree, it not hit, we can
> > merge. I have also run "xfstests quick group test cases", look like that
> > it works well. dio maybe also go to this way.
>
> The reason why we don't merge unwritten extents if there is IO to unwritten
> extents running is that we split unwritten extents to match exactly the IO
> range on submission and then convert it to written extents on IO
> completion. So we must avoid merging these split out extents while the IO
> is running.
>

I can see why it is a must for the 'delalloc' case (as we may be not
able to offer enough credits for doing split on IO completion).

However, for the 'nodelalloc' case, extent splits are done in
writepages() instead of endio, and we have reserved enough credits for
either extent allocation or extent split.

While I understand a more fine-grain track for unwritten extents is
preferable, do you think if it's OK to have a workaround like [1] to
mitigate the performance pain?

[1]: https://patchwork.ozlabs.org/patch/1000284

thanks,
liubo

> I agree that the condition in ext4_can_extents_be_merged() is rather coarse
> so it would be nice to improve it so that unwritten extents on which IO is
> not running can be merged. I've also observed that unwritten extents get
> fragmented relatively easily under some workloads.
>
> Rather than introducing new RB-tree for this (which costs additional memory
> and its maintenance costs also CPU time), I'd use extent status tree to
> identify unwritten extent that got split out when preparing the IO (you
> should mark such extent in ext4_map_blocks() when EXT4_GET_BLOCKS_IO_SUBMIT
> flag is set). Then the flag would get cleared on extent conversion to
> written one.
>
>                                                                 Honza
>
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
