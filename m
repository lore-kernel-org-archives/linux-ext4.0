From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/2 v3] EXT4: Secure Delete: Zero out file data
Date: Sat, 2 Jul 2011 12:33:00 +0300
Message-ID: <CAOQ4uxicueV9QOvHEhyk0mNSs+B+dT1X=Z64i_L2_qn6X6_vHA@mail.gmail.com>
References: <1309468923-5677-1-git-send-email-achender@linux.vnet.ibm.com>
	<1309468923-5677-2-git-send-email-achender@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Allison Henderson <achender@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53032 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab1GBJdC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 2 Jul 2011 05:33:02 -0400
Received: by wyg8 with SMTP id 8so2610139wyg.19
        for <linux-ext4@vger.kernel.org>; Sat, 02 Jul 2011 02:33:00 -0700 (PDT)
In-Reply-To: <1309468923-5677-2-git-send-email-achender@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 1, 2011 at 12:22 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> The first patch adds a new flag, EXT4_FREE_BLOCKS_ZERO,
> to ext4_free_blocks. This flag causes causes blocks to be
> zerod before they are freed. =A0Files that have the EXT4_SECRM_FL
> attribute flag on will have their blocks zerod when
> they are released. =A0The EXT4_SECRM_FL attribute flag can
> be enabled useing chattr +s
>
> Signed-off-by: Allison Henderson <achender@linux.vnet.ibm.com>
> ---
> v1->v2
> Removed check for discard mount option and replaced with
> check for secure discard and discard_zeroes_data
>
> Added BLKDEV_DISCARD_SECURE to the sb_issue_discard call
>
> v2->v3
> Removed code for discard. =A0A seperate patch will
> be done to add that code in the block layer
>
> :100644 100644 1921392... 38a4d75... M =A0fs/ext4/ext4.h
> :100644 100644 f815cc8... cf178f3... M =A0fs/ext4/extents.c
> :100644 100644 62f86e7... 8fdae7d... M =A0fs/ext4/inode.c
> :100644 100644 6ed859d... 94872b2... M =A0fs/ext4/mballoc.c
> :100644 100644 c757adc... 1ff7532... M =A0fs/ext4/xattr.c
> =A0fs/ext4/ext4.h =A0 =A0| =A0 =A01 +
> =A0fs/ext4/extents.c | =A0 =A03 +++
> =A0fs/ext4/inode.c =A0 | =A0 =A03 +++
> =A0fs/ext4/mballoc.c | =A0 =A08 ++++++++
> =A0fs/ext4/xattr.c =A0 | =A0 12 ++++++++----
> =A05 files changed, 23 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
> index 1921392..38a4d75 100644
> --- a/fs/ext4/ext4.h
> +++ b/fs/ext4/ext4.h
> @@ -526,6 +526,7 @@ struct ext4_new_group_data {
> =A0#define EXT4_FREE_BLOCKS_METADATA =A0 =A0 =A00x0001
> =A0#define EXT4_FREE_BLOCKS_FORGET =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00x0=
002
> =A0#define EXT4_FREE_BLOCKS_VALIDATED =A0 =A0 0x0004
> +#define EXT4_FREE_BLOCKS_ZERO =A0 =A0 =A0 =A0 =A00x0008
>
> =A0/*
> =A0* ioctl commands
> diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> index f815cc8..cf178f3 100644
> --- a/fs/ext4/extents.c
> +++ b/fs/ext4/extents.c
> @@ -2231,6 +2231,9 @@ static int ext4_remove_blocks(handle_t *handle,=
 struct inode *inode,
>
> =A0 =A0 =A0 =A0if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0flags |=3D EXT4_FREE_BLOCKS_METADATA;
> +
> + =A0 =A0 =A0 if (EXT4_I(inode)->i_flags & EXT4_SECRM_FL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D EXT4_FREE_BLOCKS_ZERO;
> =A0#ifdef EXTENTS_STATS
> =A0 =A0 =A0 =A0{
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct ext4_sb_info *sbi =3D EXT4_SB(i=
node->i_sb);
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 62f86e7..8fdae7d 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4182,6 +4182,9 @@ static int ext4_clear_blocks(handle_t *handle, =
struct inode *inode,
> =A0 =A0 =A0 =A0for (p =3D first; p < last; p++)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*p =3D 0;
>
> + =A0 =A0 =A0 if (EXT4_I(inode)->i_flags & EXT4_SECRM_FL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 flags |=3D EXT4_FREE_BLOCKS_ZERO;
> +
> =A0 =A0 =A0 =A0ext4_free_blocks(handle, inode, NULL, block_to_free, c=
ount, flags);
> =A0 =A0 =A0 =A0return 0;
> =A0out_err:
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index 6ed859d..94872b2 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -4485,6 +4485,14 @@ void ext4_free_blocks(handle_t *handle, struct=
 inode *inode,
> =A0 =A0 =A0 =A0ext4_debug("freeing block %llu\n", block);
> =A0 =A0 =A0 =A0trace_ext4_free_blocks(inode, block, count, flags);
>
> + =A0 =A0 =A0 if (flags & EXT4_FREE_BLOCKS_ZERO) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D sb_issue_zeroout(inode->i_sb, b=
lock, count, GFP_NOFS);

But the delete of these blocks in not yet committed,
so after reboot, you can end up with a non-deleted but zeroed file data=
=2E
Is that acceptable? I should think not.

One way around this is a 2-phase unlink/truncate.
Phase 1: add to orphan list and register a callback on commit
Phase 2: issue zeroout and free the blocks

This won't work for punch hole, but then again, for punch hole
it's probably OK to end up with zeroed data, but non-deleted blocks.
Right?

Amir.

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err < 0)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto error_return;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D 0;
> + =A0 =A0 =A0 }
> +
> =A0 =A0 =A0 =A0if (flags & EXT4_FREE_BLOCKS_FORGET) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0struct buffer_head *tbh =3D bh;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int i;
> diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
> index c757adc..1ff7532 100644
> --- a/fs/ext4/xattr.c
> +++ b/fs/ext4/xattr.c
> @@ -471,7 +471,7 @@ ext4_xattr_release_block(handle_t *handle, struct=
 inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 struct buffer_head *b=
h)
> =A0{
> =A0 =A0 =A0 =A0struct mb_cache_entry *ce =3D NULL;
> - =A0 =A0 =A0 int error =3D 0;
> + =A0 =A0 =A0 int free_blocks_flags, error =3D 0;
>
> =A0 =A0 =A0 =A0ce =3D mb_cache_entry_get(ext4_xattr_cache, bh->b_bdev=
, bh->b_blocknr);
> =A0 =A0 =A0 =A0error =3D ext4_journal_get_write_access(handle, bh);
> @@ -484,9 +484,13 @@ ext4_xattr_release_block(handle_t *handle, struc=
t inode *inode,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (ce)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0mb_cache_entry_free(ce=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0get_bh(bh);
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_free_blocks(handle, inode, bh, 0, =
1,
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4=
_FREE_BLOCKS_METADATA |
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0EXT4=
_FREE_BLOCKS_FORGET);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 free_blocks_flags =3D EXT4_FREE_BLOCKS_=
METADATA |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 EXT4_FREE_BLOCKS_FORGET;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (EXT4_I(inode)->i_flags & EXT4_SECRM=
_FL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 free_blocks_flags |=3D =
EXT4_FREE_BLOCKS_ZERO;
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ext4_free_blocks(handle, inode, bh, 0, =
1, free_blocks_flags);
> =A0 =A0 =A0 =A0} else {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0le32_add_cpu(&BHDR(bh)->h_refcount, -1=
);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0error =3D ext4_handle_dirty_metadata(h=
andle, inode, bh);
> --
> 1.7.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
