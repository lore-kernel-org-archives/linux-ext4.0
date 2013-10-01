From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 10/31] libext2fs: Allow callers to punch a single block
Date: Tue, 1 Oct 2013 14:25:11 -0700
Message-ID: <20131001212511.GB25931@birch.djwong.org>
References: <20131001012642.28415.89353.stgit@birch.djwong.org>
 <20131001012746.28415.15964.stgit@birch.djwong.org>
 <CAGW2f1GLd8wxUUW6YJ6iSOH-Ed7aAF2=6vMdBQYEkF7Ut9yfTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: jon ernst <jonernst07@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46863 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab3JAVZS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Oct 2013 17:25:18 -0400
Content-Disposition: inline
In-Reply-To: <CAGW2f1GLd8wxUUW6YJ6iSOH-Ed7aAF2=6vMdBQYEkF7Ut9yfTw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 01, 2013 at 03:09:44PM -0400, jon ernst wrote:
> On Mon, Sep 30, 2013 at 9:27 PM, Darrick J. Wong
> <darrick.wong@oracle.com> wrote:
> > The range of blocks to punch is treated as an inclusive range on both ends,
> > i.e. if start=1 and end=2, both blocks 1 and 2 are punched out.  Thus, start ==
> > end means that the caller wishes to punch a single block.  Remove the check
> > that prevents us from punching a single block.
> >
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> >  lib/ext2fs/ext2fs.h |    4 ++++
> >  lib/ext2fs/punch.c  |    5 +----
> >  2 files changed, 5 insertions(+), 4 deletions(-)
> >
> >
> > diff --git a/lib/ext2fs/ext2fs.h b/lib/ext2fs/ext2fs.h
> > index 311ceda..c37e00b 100644
> > --- a/lib/ext2fs/ext2fs.h
> > +++ b/lib/ext2fs/ext2fs.h
> > @@ -1385,6 +1385,10 @@ extern errcode_t ext2fs_check_mount_point(const char *device, int *mount_flags,
> >                                           char *mtpt, int mtlen);
> >
> >  /* punch.c */
> > +/*
> > + * NOTE: This function removes from an inode the blocks "start", "end", and
> > + * every block in between.
> > + */
> >  extern errcode_t ext2fs_punch(ext2_filsys fs, ext2_ino_t ino,
> >                               struct ext2_inode *inode,
> >                               char *block_buf, blk64_t start,
> > diff --git a/lib/ext2fs/punch.c b/lib/ext2fs/punch.c
> > index 11c7668..aac1942 100644
> > --- a/lib/ext2fs/punch.c
> > +++ b/lib/ext2fs/punch.c
> > @@ -315,9 +315,6 @@ extern errcode_t ext2fs_punch(ext2_filsys fs, ext2_ino_t ino,
> >         if (start > end)
> >                 return EINVAL;
> >
> > -       if (start == end)
> > -               return 0;
> > -
> >         /* Read inode structure if necessary */
> >         if (!inode) {
> >                 retval = ext2fs_read_inode(fs, ino, &inode_buf);
> > @@ -332,7 +329,7 @@ extern errcode_t ext2fs_punch(ext2_filsys fs, ext2_ino_t ino,
> >
> >                 if (start > ~0U)
> >                         return 0;
> > -               count = ((end - start) < ~0U) ? (end - start) : ~0U;
> > +               count = ((end - start + 1) < ~0U) ? (end - start + 1) : ~0U;
> can you simply put "count =  end - start + 1;" since you have checked
> start > end case earlier.

No.  This statement clamps 'count' at 2^32-1 (since the highest block number in
a non-extent file is 4294967295), which is necessary if the 'start' and 'end'
arguments are > 32bit arguments.  That happens in the truncate case of
ext2fs_file_set_size2().

For example, if end=0x100000080 and start=0x80, end-start+1 = 1, which is not
the behavior that we want.

For the record, if end=~0ULL and start=0, this also ensures that count=~0U.

--D

> >                 retval = ext2fs_punch_ind(fs, inode, block_buf,
> >                                           (blk_t) start, count);
> >         }
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
