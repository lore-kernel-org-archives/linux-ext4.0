From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 13/37] dumpe2fs: Display inode bitmap checksum
Date: Mon, 5 Sep 2011 12:20:51 -0700
Message-ID: <20110905192051.GV12086@tux1.beaverton.ibm.com>
References: <20110901003509.1176.51159.stgit@elm3c44.beaverton.ibm.com> <20110901003634.1176.10897.stgit@elm3c44.beaverton.ibm.com> <632170F9-0528-44AF-A299-5EE2BFEB70F2@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:46902 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab1IETUz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Sep 2011 15:20:55 -0400
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p85IuigY015207
	for <linux-ext4@vger.kernel.org>; Mon, 5 Sep 2011 14:56:44 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p85JKsBT2838566
	for <linux-ext4@vger.kernel.org>; Mon, 5 Sep 2011 15:20:54 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p85JKqXq018463
	for <linux-ext4@vger.kernel.org>; Mon, 5 Sep 2011 15:20:54 -0400
Content-Disposition: inline
In-Reply-To: <632170F9-0528-44AF-A299-5EE2BFEB70F2@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 04, 2011 at 12:30:32PM -0600, Andreas Dilger wrote:
> On 2011-08-31, at 6:36 PM, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> > Display the inode bitmap checksum for each block group.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > ---
> > misc/dumpe2fs.c |    5 +++++
> > 1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > 
> > diff --git a/misc/dumpe2fs.c b/misc/dumpe2fs.c
> > index 7d74e84..ed207cb 100644
> > --- a/misc/dumpe2fs.c
> > +++ b/misc/dumpe2fs.c
> > @@ -220,6 +220,11 @@ static void list_desc (ext2_filsys fs)
> >        print_number(ext2fs_inode_bitmap_loc(fs, i));
> >        print_bg_rel_offset(fs, ext2fs_inode_bitmap_loc(fs, i), 0,
> >                    first_block, last_block);
> > +        if (fs->super->s_desc_size >= EXT2_MIN_DESC_SIZE_64BIT &&
> > +            fs->super->s_feature_ro_compat &
> > +            EXT4_FEATURE_RO_COMPAT_METADATA_CSUM)
> > +            printf(_(", checksum 0x%08x"),
> 
> Since this line is already very long, printing "csum" should be enough. 

Ok.

--D
> 
> > +                  ext2fs_inode_bitmap_checksum(fs, i));
> >        fputs(_("\n  Inode table at "), stdout);
> >        print_range(ext2fs_inode_table_loc(fs, i),
> >                ext2fs_inode_table_loc(fs, i) +
> > 
