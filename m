From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH -V2 1/5] ext4: Remove unneeded code.
Date: Fri, 21 Nov 2008 11:20:41 -0600
Message-ID: <4926EDE9.6020005@redhat.com>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35780 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756783AbYKURVG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 21 Nov 2008 12:21:06 -0500
In-Reply-To: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> This also caused an ext4_error when mounting a file system
> with only one block group.

To make the commit log more useful, could you change it to something
more like:

ext4: Fix ext4_error case when only one block group exists

Leftover code in ext4_fill_flex_info was unconditionally calling
ext4_get_group_desc() for block group 1, and the result of that call was
never actually used.  Worse, if we have a filesystem with only 1 block
group, (bg 0), the call would fail and call ext4_error() with the message:

"EXT4-fs error (device XXX): ext4_get_group_desc: block_group >=
groups_count - block_group = 1, groups_count = 1"

when attempting to mount a 1-blockgroup filesystem.

Just remove the unused call to fix this problem.

> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/super.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 0582522..b5c7658 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1451,7 +1451,6 @@ static int ext4_fill_flex_info(struct super_block *sb)
>  	ext4_group_t flex_group_count;
>  	ext4_group_t flex_group;
>  	int groups_per_flex = 0;
> -	__u64 block_bitmap = 0;
>  	int i;
>  
>  	if (!sbi->s_es->s_log_groups_per_flex) {
> @@ -1474,9 +1473,6 @@ static int ext4_fill_flex_info(struct super_block *sb)
>  		goto failed;
>  	}
>  
> -	gdp = ext4_get_group_desc(sb, 1, &bh);
> -	block_bitmap = ext4_block_bitmap(sb, gdp) - 1;
> -
>  	for (i = 0; i < sbi->s_groups_count; i++) {
>  		gdp = ext4_get_group_desc(sb, i, &bh);
>  

