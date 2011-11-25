From: Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] ext4: fix race condition when loading block or inode bitmaps
Date: Fri, 25 Nov 2011 11:41:14 +0800
Message-ID: <CAGBYx2ZADaf1hQNzNuWG4fSgzYqBLLWCmT+qE5+mC0TxrSD09w@mail.gmail.com>
References: <1322183300-12962-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36445 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab1KYDlP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Nov 2011 22:41:15 -0500
Received: by yenl6 with SMTP id l6so732396yen.19
        for <linux-ext4@vger.kernel.org>; Thu, 24 Nov 2011 19:41:15 -0800 (PST)
In-Reply-To: <1322183300-12962-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 25, 2011 at 9:08 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> We use an separate flag in buffer head to determine whether the bitma=
p
> has been valid. =A0This is distinct from it being uptodate, due to th=
e
> uninit_bg feature. =A0More details about the rationale for this flag =
can
> be found in commit 2ccb5fb9f1. =A0We set this bitmap_uptodate bit bef=
ore
> issuing the read request, so if another CPU attempts to load the same
> block or inode bitmap, since ext4_read_{block,inode}_bitmap() checks
> the bitmap_uptodate flag without locking the buffer head, hilarity
> ensues.
>
> This result of this bug is that occasionally a block or inode gets
> allocated twice, which gets noticed when the second user of the block
> gets deleted, or when an directory suddenly becomes a regular file or
> a symlink. =A0I'm *really* surprised this doesn't happen more often; =
but
> in actual practice the fact that we tend to search for a zero bit in
> the bitmap without taking a lock, and then taking the block group loc=
k
> and double checking to see if we actually got the allocation tends to
> protect us.
It is true for inode bitmap,  but block bitmap is another story,
blocks are allocated from buddy allocator and mb_load_buddy does not
call block_read_bitmap at all.   block_read_bitmap is called in
mark_space_used, free_blocks and free_inode_pa.   So I am guessing if
mb_load_buddy calls block_read_bitmap, the bug will reproduced easily.


BTW:  It seems that we should factor code reading bitmaps.   Now there
is one function for each every bitmap.  and we can pass
read_block/inode_bitmap a flag indicates sync or async read and a flag
indicates which kind of bitmap.   Thus mb_load_buddy can use
read_bimap as well and the code will be much more maintainable.

ext4-snapshot has exclude bitmap, so if we read all bitmaps via only
one function, it would be much better.

Any opinion?

Yongqiang.


>
> This bug was introduced in commit 2ccb5fb9f1, which dates back to
> January 2009 and 2.6.29. =A0So this bug has been around for a *long*
> time. =A0(We've seen it for over a year, but rarely enough that it we
> could never find a repro case so we could study it in controlled
> circumstances.)
>
> Google-Bug-Id: 2828254
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> Cc: stable@kernel.org
> ---
> =A0fs/ext4/balloc.c | =A0 12 ++++++------
> =A0fs/ext4/ialloc.c | =A0 12 ++++++------
> =A02 files changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/fs/ext4/balloc.c b/fs/ext4/balloc.c
> index 12ccacd..4501aab 100644
> --- a/fs/ext4/balloc.c
> +++ b/fs/ext4/balloc.c
> @@ -372,7 +372,7 @@ ext4_read_block_bitmap(struct super_block *sb, ex=
t4_group_t block_group)
> =A0 =A0 =A0 =A0ext4_unlock_group(sb, block_group);
> =A0 =A0 =A0 =A0if (buffer_uptodate(bh)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* if not uninit if bh is uptodate,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* if not uninit && bh is uptodate,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * bitmap is also uptodate
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_bitmap_uptodate(bh);
> @@ -380,13 +380,12 @@ ext4_read_block_bitmap(struct super_block *sb, =
ext4_group_t block_group)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return bh;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0/*
> - =A0 =A0 =A0 =A0* submit the buffer_head for read. We can
> - =A0 =A0 =A0 =A0* safely mark the bitmap as uptodate now.
> - =A0 =A0 =A0 =A0* We do it here so the bitmap uptodate bit
> - =A0 =A0 =A0 =A0* get set with buffer lock held.
> + =A0 =A0 =A0 =A0* submit the buffer_head for read. =A0It's important=
 that we
> + =A0 =A0 =A0 =A0* *not* mark the bitmap up to date until the read is
> + =A0 =A0 =A0 =A0* completed, since we check bitmap_update() above wi=
thout
> + =A0 =A0 =A0 =A0* locking the buffer for speed reasons.
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0trace_ext4_read_block_bitmap_load(sb, block_group);
> - =A0 =A0 =A0 set_bitmap_uptodate(bh);
> =A0 =A0 =A0 =A0if (bh_submit_read(bh) < 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0put_bh(bh);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_error(sb, "Cannot read block bitm=
ap - "
> @@ -394,6 +393,7 @@ ext4_read_block_bitmap(struct super_block *sb, ex=
t4_group_t block_group)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0block_group, b=
itmap_blk);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return NULL;
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 set_bitmap_uptodate(bh);
> =A0 =A0 =A0 =A0ext4_valid_block_bitmap(sb, desc, block_group, bh);
> =A0 =A0 =A0 =A0/*
> =A0 =A0 =A0 =A0 * file system mounted not to panic on error,
> diff --git a/fs/ext4/ialloc.c b/fs/ext4/ialloc.c
> index 00beb4f..6fbae6d 100644
> --- a/fs/ext4/ialloc.c
> +++ b/fs/ext4/ialloc.c
> @@ -139,7 +139,7 @@ ext4_read_inode_bitmap(struct super_block *sb, ex=
t4_group_t block_group)
>
> =A0 =A0 =A0 =A0if (buffer_uptodate(bh)) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/*
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* if not uninit if bh is uptodate,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* if not uninit && bh is uptodate,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * bitmap is also uptodate
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0set_bitmap_uptodate(bh);
> @@ -147,13 +147,12 @@ ext4_read_inode_bitmap(struct super_block *sb, =
ext4_group_t block_group)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return bh;
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0/*
> - =A0 =A0 =A0 =A0* submit the buffer_head for read. We can
> - =A0 =A0 =A0 =A0* safely mark the bitmap as uptodate now.
> - =A0 =A0 =A0 =A0* We do it here so the bitmap uptodate bit
> - =A0 =A0 =A0 =A0* get set with buffer lock held.
> + =A0 =A0 =A0 =A0* submit the buffer_head for read. =A0It's important=
 that we
> + =A0 =A0 =A0 =A0* *not* mark the bitmap up to date until the read is
> + =A0 =A0 =A0 =A0* completed, since we check bitmap_update() above wi=
thout
> + =A0 =A0 =A0 =A0* locking the buffer for speed reasons.
> =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0trace_ext4_load_inode_bitmap(sb, block_group);
> - =A0 =A0 =A0 set_bitmap_uptodate(bh);
> =A0 =A0 =A0 =A0if (bh_submit_read(bh) < 0) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0put_bh(bh);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0ext4_error(sb, "Cannot read inode bitm=
ap - "
> @@ -161,6 +160,7 @@ ext4_read_inode_bitmap(struct super_block *sb, ex=
t4_group_t block_group)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0block_group, b=
itmap_blk);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return NULL;
> =A0 =A0 =A0 =A0}
> + =A0 =A0 =A0 set_bitmap_uptodate(bh);
> =A0 =A0 =A0 =A0return bh;
> =A0}
>
> --
> 1.7.4.1.22.gec8e1.dirty
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Best Wishes
Yongqiang Yang
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
