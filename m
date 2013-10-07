From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 01/31] tune2fs: Don't convert block # to cluster # when
 clearing uninit_bg
Date: Mon, 7 Oct 2013 14:49:45 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310071449120.1975@localhost.localdomain>
References: <20131001012642.28415.89353.stgit@birch.djwong.org> <20131001012649.28415.17225.stgit@birch.djwong.org> <alpine.LFD.2.00.1310031848270.1947@localhost.localdomain> <20131003190444.GA14971@birch.djwong.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1229976989-1381150189=:1975"
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27232 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab3JGMty (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Oct 2013 08:49:54 -0400
In-Reply-To: <20131003190444.GA14971@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1229976989-1381150189=:1975
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Thu, 3 Oct 2013, Darrick J. Wong wrote:

> Date: Thu, 3 Oct 2013 12:04:44 -0700
> From: Darrick J. Wong <darrick.wong@oracle.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: tytso@mit.edu, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 01/31] tune2fs: Don't convert block # to cluster # when
>     clearing uninit_bg
> 
> On Thu, Oct 03, 2013 at 06:53:38PM +0200, Lukáš Czerner wrote:
> > On Mon, 30 Sep 2013, Darrick J. Wong wrote:
> > 
> > > Date: Mon, 30 Sep 2013 18:26:49 -0700
> > > From: Darrick J. Wong <darrick.wong@oracle.com>
> > > To: tytso@mit.edu, darrick.wong@oracle.com
> > > Cc: linux-ext4@vger.kernel.org
> > > Subject: [PATCH 01/31] tune2fs: Don't convert block # to cluster # when
> > >     clearing uninit_bg
> > > 
> > > When we're constructing the initial block bitmap as part of removing the
> > > gdt_csum (i.e. uninit_bg) feature, we mustn't convert the block numbers to
> > > cluster numbers because ext2fs_mark_block_bitmap2() does this for us.
> > 
> > I wonder if it's possible to use the old-style bitmap interface (the
> > one which does not understand 64-bit bitmaps). If so, then you also
> > need to fix ext2fs_mark_generic_bmap() (and others) so that we
> > convert blocks to clusters if needed.
> 
> It's possible to do this (bad thing) by not specifying EXT2_FLAG_64BITS when
> calling ext2fs_openfs(); see patch 26 for a quick fix.
> 
> (I'm imagining that most bigalloc users probably want 64bit anyway?)
> 
> (No idea, bigalloc isn't (currently) my use case.)

Fair enough. The patch no. 26 seems to do the trick.

Thanks!
-Lukas

> 
> --D
> > 
> > Thanks!
> > -Lukas
> > 
> > > 
> > > Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
> > > ---
> > >  misc/tune2fs.c |   13 +++++--------
> > >  1 file changed, 5 insertions(+), 8 deletions(-)
> > > 
> > > 
> > > diff --git a/misc/tune2fs.c b/misc/tune2fs.c
> > > index ddf3259..52247e0 100644
> > > --- a/misc/tune2fs.c
> > > +++ b/misc/tune2fs.c
> > > @@ -820,20 +820,17 @@ static void disable_uninit_bg(ext2_filsys fs, __u32 csum_feature_flag)
> > >  	/* The bbitmap is zeroed; we must mark group metadata blocks in use */
> > >  	for (i = 0; i < fs->group_desc_count; i++) {
> > >  		b = ext2fs_block_bitmap_loc(fs, i);
> > > -		ext2fs_mark_block_bitmap2(fs->block_map, EXT2FS_B2C(fs, b));
> > > +		ext2fs_mark_block_bitmap2(fs->block_map, b);
> > >  		b = ext2fs_inode_bitmap_loc(fs, i);
> > > -		ext2fs_mark_block_bitmap2(fs->block_map, EXT2FS_B2C(fs, b));
> > > +		ext2fs_mark_block_bitmap2(fs->block_map, b);
> > >  
> > >  		retval = ext2fs_super_and_bgd_loc2(fs, i, &b, &c, &d, NULL);
> > >  		if (retval == 0 && b)
> > > -			ext2fs_mark_block_bitmap2(fs->block_map,
> > > -						  EXT2FS_B2C(fs, b));
> > > +			ext2fs_mark_block_bitmap2(fs->block_map, b);
> > >  		if (retval == 0 && c)
> > > -			ext2fs_mark_block_bitmap2(fs->block_map,
> > > -						  EXT2FS_B2C(fs, c));
> > > +			ext2fs_mark_block_bitmap2(fs->block_map, c);
> > >  		if (retval == 0 && d)
> > > -			ext2fs_mark_block_bitmap2(fs->block_map,
> > > -						  EXT2FS_B2C(fs, d));
> > > +			ext2fs_mark_block_bitmap2(fs->block_map, d);
> > >  		if (retval) {
> > >  			com_err("disable_uninit_bg", retval,
> > >  				"while initializing block bitmaps");
> > > 
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-1229976989-1381150189=:1975--
