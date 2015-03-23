From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext3: Remove useless condition in if statement.
Date: Mon, 23 Mar 2015 11:30:44 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1503231130060.1578@localhost.localdomain>
References: <1426820950-4720-1-git-send-email-weiyuan.wei@huawei.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	lizefan@huawei.com
To: Wei Yuan <weiyuan.wei@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1426820950-4720-1-git-send-email-weiyuan.wei@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 20 Mar 2015, Wei Yuan wrote:

> Date: Fri, 20 Mar 2015 11:09:10 +0800
> From: Wei Yuan <weiyuan.wei@huawei.com>
> To: jack@suse.cz, akpm@linux-foundation.org, adilger.kernel@dilger.ca
> Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
>     lczerner@redhat.com, lizefan@huawei.com
> Subject: [PATCH] ext3: Remove useless condition in if statement.
> 
> In this if statement, the previous condition is useless, the later one has covered it.

Nice that you've send this ext3 counterpart for ext4 patch. Thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Signed-off-by: Weiyuan <weiyuan.wei@huawei.com>
> ---
>  fs/ext3/xattr.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/ext3/xattr.c b/fs/ext3/xattr.c
> index c6874be..24215dc 100644
> --- a/fs/ext3/xattr.c
> +++ b/fs/ext3/xattr.c
> @@ -546,8 +546,7 @@ ext3_xattr_set_entry(struct ext3_xattr_info *i, struct ext3_xattr_search *s)
>  		free += EXT3_XATTR_LEN(name_len);
>  	}
>  	if (i->value) {
> -		if (free < EXT3_XATTR_SIZE(i->value_len) ||
> -		    free < EXT3_XATTR_LEN(name_len) +
> +		if (free < EXT3_XATTR_LEN(name_len) +
>  			   EXT3_XATTR_SIZE(i->value_len))
>  			return -ENOSPC;
>  	}
> 
