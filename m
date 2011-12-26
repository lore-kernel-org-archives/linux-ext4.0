From: Andreas Dilger <aedilger@gmail.com>
Subject: Re: [PATCH] ext4: avoid oversized shift in ext4_fill_flex_info()
Date: Mon, 26 Dec 2011 00:20:59 -0700
Message-ID: <C0DF217A-64C8-49E3-B979-652DB2C362C3@gmail.com>
References: <1324881404-3791-1-git-send-email-xi.wang@gmail.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Xi Wang <xi.wang@gmail.com>
To: Xi Wang <xi.wang@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43381 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab1LZHU6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 26 Dec 2011 02:20:58 -0500
Received: by yhr47 with SMTP id 47so7126498yhr.19
        for <linux-ext4@vger.kernel.org>; Sun, 25 Dec 2011 23:20:57 -0800 (PST)
In-Reply-To: <1324881404-3791-1-git-send-email-xi.wang@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-12-25, at 23:36, Xi Wang <xi.wang@gmail.com> wrote:

> Commit 503358ae fixed a division by zero, but groups_per_flex still
> overflows due to an oversized shift, given a large s_log_groups_per_flex
> like 36.  (1 << 36) is undefined in C; the result may vary depending
> on the architecture, e.g., 16 on x86, thus bypassing the sanity check
> (groups_per_flex < 2).

While this is true in theory, it is not possible to have 2^32 groups per flex group. This would mean 2^32 block bitmaps and inode bitmaps in a single group, which is impossible. 

> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> ---
> fs/ext4/super.c |    9 +++++----
> 1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 3e1329e..6deaf41 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -2010,14 +2010,15 @@ static int ext4_fill_flex_info(struct super_block *sb)
>    size_t size;
>    int i;
> 
> -    sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
> -    groups_per_flex = 1 << sbi->s_log_groups_per_flex;
> -
> -    if (groups_per_flex < 2) {
> +    if (sbi->s_es->s_log_groups_per_flex == 0 ||
> +        sbi->s_es->s_log_groups_per_flex >= 32) {
>        sbi->s_log_groups_per_flex = 0;
>        return 1;
>    }
> 
> +    sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
> +    groups_per_flex = 1 << sbi->s_log_groups_per_flex;
> +
>    /* We allocate both existing and potentially added groups */
>    flex_group_count = ((sbi->s_groups_count + groups_per_flex - 1) +
>            ((le16_to_cpu(sbi->s_es->s_reserved_gdt_blocks) + 1) <<
> -- 
> 1.7.5.4
> 
