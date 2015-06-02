From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 1/3] ext4: Verify block bitmap even after fresh
 initialization
Date: Tue, 2 Jun 2015 09:59:32 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1506020953400.4950@localhost.localdomain>
References: <1433145301-14605-1-git-send-email-lczerner@redhat.com> <3D297E12-A721-4426-9313-CB25F5280B07@dilger.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34477 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755215AbbFBH7i (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Jun 2015 03:59:38 -0400
In-Reply-To: <3D297E12-A721-4426-9313-CB25F5280B07@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 1 Jun 2015, Andreas Dilger wrote:

> Date: Mon, 1 Jun 2015 13:20:31 -0600
> From: Andreas Dilger <adilger@dilger.ca>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 1/3] ext4: Verify block bitmap even after fresh
>     initialization
> 
> 
> > On Jun 1, 2015, at 1:54 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> > 
> > If we want to rely on the buffer_verified() flag of the block bitmap
> > buffer, we have to set it consistently. However currently if we're
> > initializing uninitialized block bitmap in
> > ext4_read_block_bitmap_nowait() we're not going to set buffer verified
> > at all.
> > 
> > We can do this by simply setting the flag on the buffer, but I think
> > it's actually better to run ext4_validate_block_bitmap() to make sure
> > that what we did in the ext4_init_block_bitmap() is right.
> > 
> > So run ext4_validate_block_bitmap() even after the block bitmap
> > initialization. Also bail out early from ext4_validate_block_bitmap() if
> > we see corrupt bitmap, since we already know it's corrupt and we do not
> > need to verify that.
> > 
> > Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> > ---
> > fs/ext4/balloc.c | 4 ++--
> > 1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> > index 955bf49..cd6ea29 100644
> > --- a/fs/ext4/balloc.c
> > +++ b/fs/ext4/balloc.c
> > @@ -369,7 +369,7 @@ static void ext4_validate_block_bitmap(struct super_block *sb,
> > 	struct ext4_group_info *grp = ext4_get_group_info(sb, block_group);
> > 	struct ext4_sb_info *sbi = EXT4_SB(sb);
> > 
> > -	if (buffer_verified(bh))
> > +	if (buffer_verified(bh) || EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
> > 		return;
> > 
> > 	ext4_lock_group(sb, block_group);
> > @@ -446,7 +446,7 @@ ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group)
> > 		unlock_buffer(bh);
> > 		if (err)
> > 			ext4_error(sb, "Checksum bad for grp %u", block_group);
> > -		return bh;
> > +		goto verify;
> 
> (defect) This looks like it will miss the ext4_unlock_group() call
> below, since that is missing in the "verify:" branch.  Either you
> need to add an explicit ext4_unlock_group() call before "goto verify",
> or add a new "unlock_group:" label that unlocks the group.

Hi,

the code snippet tricked you ;). Take a look at the code there is
ext4_unlock_group() just before unlock_buffer() which is missing in
the snipper above.

Thanks!
-Lukas

> 
> 
> > 	}
> > 	ext4_unlock_group(sb, block_group);
> > 	if (buffer_uptodate(bh)) {
> 
> Cheers, Andreas
> 
> 
> 
> 
> 
> 
