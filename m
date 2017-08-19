From: Eric Sandeen <esandeen@redhat.com>
Subject: Re: [PATCH 1/2] ext4: Delete an error message for a failed memory
 allocation in ext4_multi_mount_protect()
Date: Sat, 19 Aug 2017 12:08:29 -0500
Message-ID: <b21f6c3d-2cad-3f72-f410-f608ea5f4cea@redhat.com>
References: <ca49a6dc-f2ee-d427-5f16-052706277b38@users.sourceforge.net>
 <5bf432ae-398d-718c-8105-3092a240a8ef@users.sourceforge.net>
Reply-To: sandeen@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5bf432ae-398d-718c-8105-3092a240a8ef@users.sourceforge.net>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 8/19/17 6:47 AM, SF Markus Elfring wrote:
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Sat, 19 Aug 2017 13:04:50 +0200
> 
> Omit an extra message for a memory allocation failure in this function.

I might be dense, but what makes this message "extra?"

(I suppose kmalloc squawks too if it fails, but is Coccinelle
now warning about explicit memory allocation failure warnings?)

-Eric
 
> This issue was detected by using the Coccinelle software.
> 
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
> ---
>  fs/ext4/mmp.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
> index eb9835638680..1ce00453f612 100644
> --- a/fs/ext4/mmp.c
> +++ b/fs/ext4/mmp.c
> @@ -371,7 +371,6 @@ int ext4_multi_mount_protect(struct super_block *sb,
> -	if (!mmpd_data) {
> -		ext4_warning(sb, "not enough memory for mmpd_data");
> +	if (!mmpd_data)
>  		goto failed;
> -	}
> +
>  	mmpd_data->sb = sb;
>  	mmpd_data->bh = bh;
>  
> 
