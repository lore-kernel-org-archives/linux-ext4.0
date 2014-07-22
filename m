From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH 02/24] debugfs: Only print the first 60 bytes from
 i_block on a fast symlink
Date: Tue, 22 Jul 2014 13:34:38 -0700
Message-ID: <20140722203438.GC8628@birch.djwong.org>
References: <20140718225200.31374.85411.stgit@birch.djwong.org>
 <20140718225224.31374.15186.stgit@birch.djwong.org>
 <B72871BE-3D5E-4A07-8EDE-9B4032119174@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "tytso@mit.edu" <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19162 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbaGVUep (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jul 2014 16:34:45 -0400
Content-Disposition: inline
In-Reply-To: <B72871BE-3D5E-4A07-8EDE-9B4032119174@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jul 19, 2014 at 10:49:35AM -0600, Andreas Dilger wrote:
> Wouldn't it be better to decode and print the whole symlink from the inline
> data?  Depending on the use of debugfs, printing only the first 60 bytes may
> cause people/scripts to think the link is corrupted. 

Hmm, you're right, this /does/ expose some weird behavior w.r.t. fast link
printing.  I think I should go further and inhibit printing of system.data
entirely during xattr dump since dump_inode doesn't print file contents, and
the inline data could be fairly long.

Ok, I retract this patch and I'll repost it as part of the inline data cleanup
later this week.

--D
> 
> Cheers, Andreas
> 
> > On Jul 18, 2014, at 16:52, "Darrick J. Wong" <darrick.wong@oracle.com> wrote:
> > 
> > If we have an inline_data fast symlink, i_size can be larger than the
> > size of i_block.  In this case, debugfs prints off the end of the
> > buffer, so fix that.
> > 
> > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > ---
> > debugfs/debugfs.c            |   15 ++++++++++-----
> > tests/d_special_files/expect |    2 +-
> > 2 files changed, 11 insertions(+), 6 deletions(-)
> > 
> > 
> > diff --git a/debugfs/debugfs.c b/debugfs/debugfs.c
> > index 51f386b..5eecabe 100644
> > --- a/debugfs/debugfs.c
> > +++ b/debugfs/debugfs.c
> > @@ -783,11 +783,16 @@ void internal_dump_inode(FILE *out, const char *prefix,
> >    }
> > 
> >    if (LINUX_S_ISLNK(inode->i_mode) &&
> > -        ext2fs_inode_data_blocks(current_fs,inode) == 0 &&
> > -        !(inode->i_flags & EXT4_INLINE_DATA_FL))
> > -        fprintf(out, "%sFast_link_dest: %.*s\n", prefix,
> > -            (int) inode->i_size, (char *)inode->i_block);
> > -    else if (LINUX_S_ISBLK(inode->i_mode) || LINUX_S_ISCHR(inode->i_mode)) {
> > +        ext2fs_inode_data_blocks(current_fs, inode) == 0 &&
> > +        !(inode->i_flags & EXT4_INLINE_DATA_FL)) {
> > +        int sz = EXT2_I_SIZE(inode);
> > +
> > +        if (sz > sizeof(inode->i_block))
> > +            sz = sizeof(inode->i_block);
> > +        fprintf(out, "%sFast link dest: \"%.*s\"\n", prefix, sz,
> > +            (char *)inode->i_block);
> > +    } else if (LINUX_S_ISBLK(inode->i_mode) ||
> > +           LINUX_S_ISCHR(inode->i_mode)) {
> >        int major, minor;
> >        const char *devnote;
> > 
> > diff --git a/tests/d_special_files/expect b/tests/d_special_files/expect
> > index 2b2dbfa..f729b0f 100644
> > --- a/tests/d_special_files/expect
> > +++ b/tests/d_special_files/expect
> > @@ -11,7 +11,7 @@ Fragment:  Address: 0    Number: 0    Size: 0
> > ctime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
> > atime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
> > mtime: 0x50f560e0 -- Tue Jan 15 14:00:00 2013
> > -Fast_link_dest: bar
> > +Fast link dest: "bar"
> > Exit status is 0
> > debugfs -R ''stat foo2'' -w test.img
> > Inode: 13   Type: symlink    Mode:  0777   Flags: 0x0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
