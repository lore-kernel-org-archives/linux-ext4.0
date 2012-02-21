From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: e2fsck discard errors
Date: Tue, 21 Feb 2012 08:28:10 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1202210821460.7536@dhcp-27-109.brq.redhat.com>
References: <4F42B37C.1000200@ubuntu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593Ab2BUH2S (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Feb 2012 02:28:18 -0500
In-Reply-To: <4F42B37C.1000200@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 20 Feb 2012, Phillip Susi wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> I was experimenting with e2fsck -E discard on image files and found
> some errors introduced by commit efa1a355.  The following section of
> code attempts to discard unused portions of the inode table:
> 
> 
> /* Discard inode table */
> if (ctx->options & E2F_OPT_DISCARD) {
>         blk64_t used_blks, blk, num;
> 
>         used_blks = DIV_ROUND_UP(
>                 (EXT2_INODES_PER_GROUP(fs->super) -
>                  group_free),
>                 EXT2_INODES_PER_BLOCK(fs->super));
> 
>         blk = ext2fs_inode_table_loc(fs, group) +
>                 used_blks;
>         num = fs->inode_blocks_per_group -
>                 used_blks;
>         e2fsck_discard_blocks(ctx, manager, blk, num);
> }
> 
> There are two problems with this.  The first is that trying to discard
> a count of zero blocks results in an -EINVAL, which silently halts (
> shouldn't this at least issue a warning? ) further discard attempts.
> The second I noticed after fixing that problem and had a bunch of
> valid inodes discarded.  It looks like the intent of this code is to
> free the part of the inode table that lies beyond the highest used
> inode, but instead it is using the count of free inodes, so when you
> have some free inodes followed by some used inodes, the used inodes at
> the end get discarded.
> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.17 (MingW32)
> Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/
> 
> iQEcBAEBAgAGBQJPQrN8AAoJEJrBOlT6nu75X+cH/RkJeOCGM574YabLu081oGC1
> d59Y9Q3gD0jswTtceFFLHWQkRsI6IiRznEp6h+IMixl7VARL6q8eoFWW0iIWqjkX
> mCle03+fORxXOv2U4qg3bud5gZ4jDKW7cKZvKl+LbOFFuV11W8UKdmgDqL0HyUxh
> bIC5lyUCHEWSm6/ellfSRJDFLL0ygw2irktjyszIgAGPfnbtH/fu3E0se98ke9P5
> 5j8jQSeONJA5VDOtVnsLR3TD9SnnhBrtbjkzSbqBDMBSy+/ji0208CY5UyrxX0y8
> Oh3pWsi6GAgAKdQgVdv/acRTirOkXLMLMK0SuoUuxIlzmrAIolWI2CO8DinwZ3U=
> =8H+8
> -----END PGP SIGNATURE-----
> 

Oops, thanks for noticing. You're right with both problems you're
describing. I'll make a patch so that we discard only unused parts of
inode table.

Thanks again!
-Lukas
