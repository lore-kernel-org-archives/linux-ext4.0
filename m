From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext3: fix return values on parse_options() failure
Date: Tue, 9 Oct 2012 08:19:42 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1210090814420.11244@dhcp-1-104.brq.redhat.com>
References: <5073BABF.8090206@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	serge.hallyn@canonical.com, containers@lists.linux-foundation.org
To: Zhao Hongjiang <zhaohongjiang37@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab2JIGT6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 9 Oct 2012 02:19:58 -0400
In-Reply-To: <5073BABF.8090206@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 9 Oct 2012, Zhao Hongjiang wrote:

> Date: Tue, 09 Oct 2012 13:48:47 +0800
> From: Zhao Hongjiang <zhaohongjiang37@gmail.com>
> To: jack@suse.cz
> Cc: akpm@linux-foundation.org, adilger.kernel@dilger.ca,
>     linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
>     Eric W. Biederman <ebiederm@xmission.com>, serge.hallyn@canonical.com,
>     containers@lists.linux-foundation.org
> Subject: [PATCH] ext3: fix return values on parse_options() failure
> 
> From: Zhao Hongjiang <zhaohongjiang@huawei.com>
> 
> parse_options() in ext3 should return 0 when parse the mount options fails.
> 

Ah, it really is a joy to read the parse_options() :). But this fix
makes sense, thanks for catching it.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

-Lukas

> Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
> ---
>  fs/ext3/super.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/super.c b/fs/ext3/super.c
> index 17ae5c8..ebf8312 100644
> --- a/fs/ext3/super.c
> +++ b/fs/ext3/super.c
> @@ -1001,7 +1001,7 @@ static int parse_options (char *options, struct super_block *sb,
>  			uid = make_kuid(current_user_ns(), option);
>  			if (!uid_valid(uid)) {
>  				ext3_msg(sb, KERN_ERR, "Invalid uid value %d", option);
> -				return -1;
> +				return 0;
> 
>  			}
>  			sbi->s_resuid = uid;
> @@ -1012,7 +1012,7 @@ static int parse_options (char *options, struct super_block *sb,
>  			gid = make_kgid(current_user_ns(), option);
>  			if (!gid_valid(gid)) {
>  				ext3_msg(sb, KERN_ERR, "Invalid gid value %d", option);
> -				return -1;
> +				return 0;
>  			}
>  			sbi->s_resgid = gid;
>  			break;
> -- 1.7.1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
