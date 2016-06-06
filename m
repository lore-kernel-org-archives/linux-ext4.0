From: Lin Feng <linf@chinanetcenter.com>
Subject: Re: [PATCH] ext4: mballoc.c: fix ac_g_ex and ac_f_ex misuse bug in
 EXT4_MB_HINT_TRY_GOAL path
Date: Mon, 06 Jun 2016 10:23:43 +0800
Message-ID: <5754DEAF.7010705@chinanetcenter.com>
References: <1464868898-31336-1-git-send-email-linf@chinanetcenter.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: tytso@mit.edu, adilger.kernel@dilger.ca
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.chinanetcenter.com ([123.103.13.31]:43654 "EHLO
	chinanetcenter.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752030AbcFFCZL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 5 Jun 2016 22:25:11 -0400
In-Reply-To: <1464868898-31336-1-git-send-email-linf@chinanetcenter.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Am I missing something or it's not important at all?

Other things:
[linfeng@localhost ext4]$ grep EXT4_MB_HINT_MERGE ./* -rHn
./ext4.h:111:#define EXT4_MB_HINT_MERGE        0x0001
./mballoc.c:1871:    } else if (max > 0 && (ac->ac_flags & EXT4_MB_HINT_MERGE)) {

EXT4_MB_HINT_MERGE is only tested once and nowhere teaches how to use it.
IIUC it also should be folded into EXT4_MB_HINT_TRY_GOAL path or simply skip
EXT4_MB_HINT_MERGE test at -L1871.

thanks,
linfeng


On 06/02/2016 08:01 PM, Lin Feng wrote:
> Descriptions:
> ext4 block allocation core stack:
> ext4_mb_new_blocks
>    ext4_mb_normalize_request
>    ext4_mb_regular_allocator
>      ext4_mb_find_by_goal
>        mb_find_extent(e4b, ac->ac_g_ex.fe_start, ac->ac_g_ex.fe_len, &ex);
>
> The start block searching hint for merging(use EXT4_MB_HINT_TRY_GOAL flag)
> set in ext4_mb_normalize_request is stored in ac_f_ex, while in
> EXT4_MB_HINT_TRY_GOAL path which falls in ext4_mb_find_by_goal always use
> ac_g_ex as a hint and the hint set in ext4_mb_normalize_request is never
> use.
>
> We could hit this bug by writing a sparse file from backward mode and the
> file may get fragments even if the physical blocks in the hole is free,
> which is expected to be merged into a single extent.
>
> Signed-off-by: Lin Feng <linf@chinanetcenter.com>
> ---
>   fs/ext4/mballoc.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> index c1ab3ec..e31fc63 100644
> --- a/fs/ext4/mballoc.c
> +++ b/fs/ext4/mballoc.c
> @@ -3198,15 +3198,15 @@ ext4_mb_normalize_request(struct ext4_allocation_context *ac,
>   	if (ar->pright && (ar->lright == (start + size))) {
>   		/* merge to the right */
>   		ext4_get_group_no_and_offset(ac->ac_sb, ar->pright - size,
> -						&ac->ac_f_ex.fe_group,
> -						&ac->ac_f_ex.fe_start);
> +						&ac->ac_g_ex.fe_group,
> +						&ac->ac_g_ex.fe_start);
>   		ac->ac_flags |= EXT4_MB_HINT_TRY_GOAL;
>   	}
>   	if (ar->pleft && (ar->lleft + 1 == start)) {
>   		/* merge to the left */
>   		ext4_get_group_no_and_offset(ac->ac_sb, ar->pleft + 1,
> -						&ac->ac_f_ex.fe_group,
> -						&ac->ac_f_ex.fe_start);
> +						&ac->ac_g_ex.fe_group,
> +						&ac->ac_g_ex.fe_start);
>   		ac->ac_flags |= EXT4_MB_HINT_TRY_GOAL;
>   	}
>
>

