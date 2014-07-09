From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: [PATCH 1/3] journal: use consts instead of 1024 and add helper
 for journal with 1k blocksize
Date: Wed, 9 Jul 2014 07:51:36 +0400
Message-ID: <20140709035136.GF4622@azat>
References: <1404852082-1550-1-git-send-email-a3at.mail@gmail.com>
 <1404852082-1550-2-git-send-email-a3at.mail@gmail.com>
 <D7E9803B-18EC-4E23-BD3A-4A3B7802C735@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:41227 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaGIDvk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Jul 2014 23:51:40 -0400
Received: by mail-la0-f43.google.com with SMTP id e16so4655353lan.30
        for <linux-ext4@vger.kernel.org>; Tue, 08 Jul 2014 20:51:38 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <D7E9803B-18EC-4E23-BD3A-4A3B7802C735@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 08, 2014 at 05:30:10PM -0600, Andreas Dilger wrote:
> On Jul 8, 2014, at 2:41 PM, Azat Khuzhin <a3at.mail@gmail.com> wrote:
> > Use EXT2_MIN_BLOCK_SIZE/JFS_MIN_JOURNAL_BLOCKS instead of hardcoded 1024
> > when it is okay, and also add a helper ext2fs_journal_sb_start() that
> > will return start of journal sb with special case for fs with 1k block
> > size.
> 
> Seems like a good idea, but an issue below.
> 
> > diff --git a/lib/ext2fs/mkjournal.c b/lib/ext2fs/mkjournal.c
> > index 884d9c0..068eed7 100644
> > --- a/lib/ext2fs/mkjournal.c
> > +++ b/lib/ext2fs/mkjournal.c
> > @@ -75,10 +75,7 @@ errcode_t ext2fs_create_journal_superblock(ext2_filsys fs,
> > 	if (fs->super->s_feature_incompat &
> > 	    EXT3_FEATURE_INCOMPAT_JOURNAL_DEV) {
> > 		jsb->s_nr_users = 0;
> > -		if (fs->blocksize == 1024)
> > -			jsb->s_first = htonl(3);
> > -		else
> > -			jsb->s_first = htonl(2);
> > +		jsb->s_first = ext2fs_journal_sb_start(fs->blocksize) + 1;
> 
> This looks like it is missing the htonl() conversion, and will break the on-disk format?

Yeah, good catch, thanks!
I will resend this patch with htonl().

Cheers, Azat.

> 
> The JBD code stores all data on-disk in big-endian to ensure that it is converted properly
> on the most common little-endian systems, and will therefore also work on big-endian systems.
> 
> Cheers, Andreas
> 
> 
> 
> 
> 



-- 
Respectfully
Azat Khuzhin
