From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 14/51] dumpe2fs: Display block bitmap checksum
Date: Mon, 19 Dec 2011 11:50:14 -0800
Message-ID: <20111219195014.GI8233@tux1.beaverton.ibm.com>
References: <20111214011316.20947.13706.stgit@elm3c44.beaverton.ibm.com> <20111214011450.20947.33903.stgit@elm3c44.beaverton.ibm.com> <32C86905-38C6-4897-8A98-26431DB73118@dilger.ca>
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
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46077 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753007Ab1LSTwz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 19 Dec 2011 14:52:55 -0500
Received: from /spool/local
	by e5.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Mon, 19 Dec 2011 14:52:52 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay01.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pBJJoH35269174
	for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 14:50:17 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pBJJoFCa014124
	for <linux-ext4@vger.kernel.org>; Mon, 19 Dec 2011 17:50:17 -0200
Content-Disposition: inline
In-Reply-To: <32C86905-38C6-4897-8A98-26431DB73118@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 19, 2011 at 11:50:06AM +0100, Andreas Dilger wrote:
> On 2011-12-14, at 2:14 AM, Darrick J. Wong wrote:
> > Display the block bitmap checksum when displaying block groups.
> > 
> > diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> > index 98bee2b..33c0933 100644
> > --- a/misc/dumpe2fs.c
> > +++ b/misc/dumpe2fs.c
> > @@ -222,6 +222,11 @@ static void list_desc (ext2_filsys fs)
> > 		print_number(ext2fs_block_bitmap_loc(fs, i));
> > 		print_bg_rel_offset(fs, ext2fs_block_bitmap_loc(fs, i), 0,
> > 				    first_block, last_block);
> > +		if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT &&
> > +		    fs->super->s_feature_ro_compat &
> > +		    EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
> > +			printf(_(", csum 0x%08x"),
> > +			       ext2fs_block_bitmap_checksum(fs, i));
> 
> Printing the checksum should only depend on METADATA_CSUM, and has nothing
> to do with DESC_SIZE_64BIT.  That is a holdover from when there was only
> a 32-bit checksum for the inode/block bitmaps and no 16-bit checksum in
> the small group descriptor.

Oops, I will fix both of these.  Thank you for catching them!

--D
> 
> Cheers, Andreas
> 
> 
> 
> 
> 

