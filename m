From: "Amir G." <amir73il@users.sourceforge.net>
Subject: Re: [PATCH] libext2fs: fix the range validation in bitmap_range2 funcs
Date: Thu, 15 Sep 2011 09:54:13 +0300
Message-ID: <CAOQ4uxgGQGFVwnXViv3fDqVnO4nPgrcX-gA7gZNG4=tBXVO9EA@mail.gmail.com>
References: <1308064592-29935-1-git-send-email-amir73il@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44304 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1IOGyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 15 Sep 2011 02:54:14 -0400
Received: by wyh22 with SMTP id 22so2384555wyh.19
        for <linux-ext4@vger.kernel.org>; Wed, 14 Sep 2011 23:54:13 -0700 (PDT)
In-Reply-To: <1308064592-29935-1-git-send-email-amir73il@users.sourceforge.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jun 14, 2011 at 6:16 PM,  <amir73il@users.sourceforge.net> wrot=
e:
> From: Amir Goldstein <amir73il@users.sf.net>
>
> The condition ((start+num) & ~0xffffffffULL) in bitmap_ragne2
> and generic_bmap_range funcs in get_bitmap64.c was wrong and
> inconsistent with the condition (start+num-1 > bmap->real_end)
> in generic_bitmap_range funcs in get_bitmap.c.
>
> I got the following error from tune2fs on a 16TB fs:
> Illegal block number passed to ext2fs_unmark_block_bitmap #4294967295
> for block bitmap for 16TB.img
> tune2fs: Invalid argument while reading bitmaps
>
> Fix to condition to ((start+num-1) & ~0xffffffffULL), because
> the bit (start+num) is not going to be changed by the funcs.
>
> Signed-off-by: Amir Goldstein <amir73il@users.sf.net>

ping

> ---
> =A0lib/ext2fs/gen_bitmap64.c | =A0 10 +++++-----
> =A01 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/lib/ext2fs/gen_bitmap64.c b/lib/ext2fs/gen_bitmap64.c
> index df095ac..69c399a 100644
> --- a/lib/ext2fs/gen_bitmap64.c
> +++ b/lib/ext2fs/gen_bitmap64.c
> @@ -382,7 +382,7 @@ errcode_t ext2fs_set_generic_bmap_range(ext2fs_ge=
neric_bitmap bmap,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return EINVAL;
>
> =A0 =A0 =A0 =A0if (EXT2FS_IS_32_BITMAP(bmap)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((start+num) & ~0xffffffffULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((start+num-1) & ~0xffffffffULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs_warn_bitmap2(bm=
ap, EXT2FS_UNMARK_ERROR,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A00xffffffff);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return EINVAL;
> @@ -405,7 +405,7 @@ errcode_t ext2fs_get_generic_bmap_range(ext2fs_ge=
neric_bitmap bmap,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return EINVAL;
>
> =A0 =A0 =A0 =A0if (EXT2FS_IS_32_BITMAP(bmap)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((start+num) & ~0xffffffffULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((start+num-1) & ~0xffffffffULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs_warn_bitmap2(bm=
ap,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0EXT2FS_UNMARK_ERROR, 0xffffffff);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return EINVAL;
> @@ -476,7 +476,7 @@ int ext2fs_test_block_bitmap_range2(ext2fs_block_=
bitmap bmap,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 bmap, block);
>
> =A0 =A0 =A0 =A0if (EXT2FS_IS_32_BITMAP(bmap)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((block+num) & ~0xffffffffULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((block+num-1) & ~0xffffffffULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs_warn_bitmap2((e=
xt2fs_generic_bitmap) bmap,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0EXT2FS_UNMARK_ERROR, 0xffffffff);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return EINVAL;
> @@ -498,7 +498,7 @@ void ext2fs_mark_block_bitmap_range2(ext2fs_block=
_bitmap bmap,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>
> =A0 =A0 =A0 =A0if (EXT2FS_IS_32_BITMAP(bmap)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((block+num) & ~0xffffffffULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((block+num-1) & ~0xffffffffULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs_warn_bitmap2((e=
xt2fs_generic_bitmap) bmap,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0EXT2FS_UNMARK_ERROR, 0xffffffff);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> @@ -526,7 +526,7 @@ void ext2fs_unmark_block_bitmap_range2(ext2fs_blo=
ck_bitmap bmap,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
>
> =A0 =A0 =A0 =A0if (EXT2FS_IS_32_BITMAP(bmap)) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((block+num) & ~0xffffffffULL) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if ((block+num-1) & ~0xffffffffULL) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext2fs_warn_bitmap2((e=
xt2fs_generic_bitmap) bmap,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0EXT2FS_UNMARK_ERROR, 0xffffffff);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return;
> --
> 1.7.4.1
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
