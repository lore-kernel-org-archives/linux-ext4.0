From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 1/3] ext4: Verify block bitmap even after fresh initialization
Date: Mon, 1 Jun 2015 13:20:31 -0600
Message-ID: <3D297E12-A721-4426-9313-CB25F5280B07@dilger.ca>
References: <1433145301-14605-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:35383 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488AbbFATUf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Jun 2015 15:20:35 -0400
Received: by pdbnf5 with SMTP id nf5so53437435pdb.2
        for <linux-ext4@vger.kernel.org>; Mon, 01 Jun 2015 12:20:35 -0700 (PDT)
In-Reply-To: <1433145301-14605-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


> On Jun 1, 2015, at 1:54 AM, Lukas Czerner <lczerner@redhat.com> wrote:
> 
> If we want to rely on the buffer_verified() flag of the block bitmap
> buffer, we have to set it consistently. However currently if we're
> initializing uninitialized block bitmap in
> ext4_read_block_bitmap_nowait() we're not going to set buffer verified
> at all.
> 
> We can do this by simply setting the flag on the buffer, but I think
> it's actually better to run ext4_validate_block_bitmap() to make sure
> that what we did in the ext4_init_block_bitmap() is right.
> 
> So run ext4_validate_block_bitmap() even after the block bitmap
> initialization. Also bail out early from ext4_validate_block_bitmap() if
> we see corrupt bitmap, since we already know it's corrupt and we do not
> need to verify that.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> ---
> fs/ext4/balloc.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 955bf49..cd6ea29 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -369,7 +369,7 @@ static void ext4_validate_block_bitmap(struct super_block *sb,
> 	struct ext4_group_info *grp = ext4_get_group_info(sb, block_group);
> 	struct ext4_sb_info *sbi = EXT4_SB(sb);
> 
> -	if (buffer_verified(bh))
> +	if (buffer_verified(bh) || EXT4_MB_GRP_BBITMAP_CORRUPT(grp))
> 		return;
> 
> 	ext4_lock_group(sb, block_group);
> @@ -446,7 +446,7 @@ ext4_read_block_bitmap_nowait(struct super_block *sb, ext4_group_t block_group)
> 		unlock_buffer(bh);
> 		if (err)
> 			ext4_error(sb, "Checksum bad for grp %u", block_group);
> -		return bh;
> +		goto verify;

(defect) This looks like it will miss the ext4_unlock_group() call
below, since that is missing in the "verify:" branch.  Either you
need to add an explicit ext4_unlock_group() call before "goto verify",
or add a new "unlock_group:" label that unlocks the group.


> 	}
> 	ext4_unlock_group(sb, block_group);
> 	if (buffer_uptodate(bh)) {

Cheers, Andreas





