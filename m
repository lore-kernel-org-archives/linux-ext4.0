From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 08/51] mke2fs: Allow metadata checksums to be turned on
	at mkfs time
Date: Mon, 19 Dec 2011 08:59:51 -0800
Message-ID: <20111219165951.GE8233@tux1.beaverton.ibm.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com> <20111214011410.20947.96920.stgit@elm3c44.beaverton.ibm.com> <76441870-91E6-402F-B1F7-F67C97D0B02B@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>, linux-ext4@vger.kernel.org,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48637 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752129Ab1LSRFk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Dec 2011 12:05:40 -0500
Received: from /spool/local
	by e2.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 19 Dec 2011 12:05:28 -0500
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBJH0wMF096538
	for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 12:01:00 -0500
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBJGxqca019856
	for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 09:59:53 -0700
Content-Disposition: inline
In-Reply-To: <76441870-91E6-402F-B1F7-F67C97D0B02B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 19, 2011 at 11:28:44AM +0100, Andreas Dilger wrote:
> On 2011-12-14, at 2:14 AM, Darrick J. Wong wrote:
> > Write out checksummed inodes even when writing out a zeroed table.
> 
> Looking at the code, this is only writing out checksummed inodes
> for the reserved inodes, not all of them, right?  Otherwise, going
> back to writing out the whole inode table would be really slowing
> down mke2fs compared to lazy_itable_init.

Assuming that the inodes numbered less than EXT2_FIRST_INO are reserved, then
yes it should be only writing reserved inodes (unless the user forces mkfs to
write all inodes).

--D
> 
> > diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> > index 0ef2531..98af8b0 100644
> > --- a/misc/mke2fs.c
> > +++ b/misc/mke2fs.c
> > @@ -305,6 +305,27 @@ _("Warning: the backup superblock/group descriptors at block %u contain\n"
> > 	ext2fs_badblocks_list_iterate_end(bb_iter);
> > }
> > 
> > +static void write_reserved_inodes(ext2_filsys fs)
> > +{
> > +	errcode_t	retval;
> > +	ext2_ino_t	ino;
> > +	struct ext2_inode *inode;
> > +
> > +	retval = ext2fs_get_mem(EXT2_INODE_SIZE(fs->super), &inode);
> > +	if (retval) {
> > +		com_err("inode_init", retval,
> > +			"while allocating memory");
> > +		exit(1);
> > +	}
> > +	bzero(inode, EXT2_INODE_SIZE(fs->super));
> > +
> > +	for (ino = 1; ino < EXT2_FIRST_INO(fs->super); ino++)
> > +		ext2fs_write_inode_full(fs, ino, inode,
> > +					EXT2_INODE_SIZE(fs->super));
> > +
> > +	ext2fs_free_mem(&inode);
> > +}
> > +
> > static void write_inode_tables(ext2_filsys fs, int lazy_flag, int itable_zeroed)
> > {
> > 	errcode_t	retval;
> > @@ -350,6 +371,12 @@ static void write_inode_tables(ext2_filsys fs, int lazy_flag, int itable_zeroed)
> > 	ext2fs_zero_blocks2(0, 0, 0, 0, 0);
> > 	ext2fs_numeric_progress_close(fs, &progress,
> > 				      _("done                            \n"));
> > +
> > +	/* Reserved inodes must always have correct checksums */
> > +	if (fs->super->s_creator_os == EXT2_OS_LINUX &&
> > +	    fs->super->s_feature_ro_compat &
> > +	    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
> > +		write_reserved_inodes(fs);
> 
> > }
> 
> 
> Cheers, Andreas
> 
> 
> 
> 
> 

