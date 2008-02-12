From: Andreas Dilger <adilger@sun.com>
Subject: Re: EXT4_FEATURE_RO_COMPAT_DIR_NLINK and the directory size.
Date: Tue, 12 Feb 2008 15:56:42 -0700
Message-ID: <20080212225642.GS3029@webber.adilger.int>
References: <20080212123632.GA16634@skywalker>
 <20080212135342.GB16634@skywalker> <20080212150516.GC16634@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:42532 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbYBLW5K (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 12 Feb 2008 17:57:10 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m1CMv9Aw026315
	for <linux-ext4@vger.kernel.org>; Tue, 12 Feb 2008 14:57:09 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JW500001E9WWT00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 12 Feb 2008 14:57:09 -0800 (PST)
In-reply-to: <20080212150516.GC16634@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 12, 2008  20:35 +0530, Aneesh Kumar K.V wrote:
> On Tue, Feb 12, 2008 at 07:23:42PM +0530, Aneesh Kumar K.V wrote:
> > On Tue, Feb 12, 2008 at 06:06:32PM +0530, Aneesh Kumar K.V wrote:
> > > Also after running fsstress fsck fails with zero size directory on
> > > powerpc. I am finding directories with 
> > > 
> > > i_links_count == 1
> > > i_blocks == 0

Is this after some failure to create a subdirectory (e.g. ENOSPC)?

> > (gdb) p *inode
> > $1 = {i_mode = 16895, i_uid = 0, i_size = 4096, i_atime = 1202822535, i_ctime = 1202822535, i_mtime = 1202822535, i_dtime = 0,
> > i_gid = 0, i_links_count = 1, i_blocks = 0, i_flags = 524288, osd1 = {linux1 = {l_i_version = 1}, hurd1 = {h_i_translator = 1},
> > masix1 = {m_i_reserved1 = 1}}, i_block = {4077518848, 262144, 0 <repeats 13 times>}, i_generation = 2950864834, i_file_acl = 0,
> > i_dir_acl = 0, i_faddr = 0, osd2 = {linux2 = {l_i_blocks_hi = 0, i_pad1 = 0, l_i_uid_high = 0, l_i_gid_high = 0, l_i_reserved2 = 0},
> > hurd2 = {h_i_frag = 0 '\0', h_i_fsize = 0 '\0', h_i_mode_high = 0, h_i_uid_high = 0, h_i_gid_high = 0, h_i_author = 0}, masix2 = {
> > m_i_frag = 0 '\0', m_i_fsize = 0 '\0', m_pad1 = 0, m_i_reserved2 = {0, 0}}}}

This is the subdirectory inode?  The i_block values are the extent magic,
and i_flags = EXTENT_FL it appears (which is fine).

> Right now waiting for the test to finish with this change.
> 
> diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
> index a9347fb..fd3b031 100644
> --- a/fs/ext4/namei.c
> +++ b/fs/ext4/namei.c
> @@ -1805,7 +1805,7 @@ retry:
>  	inode->i_size = EXT4_I(inode)->i_disksize = inode->i_sb->s_blocksize;
>  	dir_block = ext4_bread (handle, inode, 0, 1, &err);
>  	if (!dir_block) {
> -		ext4_dec_count(handle, inode); /* is this nlink == 0? */
> +		drop_nlink(inode);
>  		ext4_mark_inode_dirty(handle, inode);
>  		iput (inode);
>  		goto out_stop;

It's entirely possible this is the right fix.  The code was changed for
all directory inodes replacing drop_nlink() (or its predecessor) with
ext4_dec_count().  In most cases this is correct, but it seems here it
isn't very clear (even with the useless comment) that the intention is
to drop the nlinks to 0 for the new directory inode.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.
