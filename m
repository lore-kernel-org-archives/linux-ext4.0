From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 20/24] ext4: return actual error on ext4_init_fs
Date: Tue, 17 Jun 2014 17:13:27 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1406171712170.2148@localhost.localdomain>
References: <53A05196.60801@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Jeff Liu <jeff.liu@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932999AbaFQPNg (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 17 Jun 2014 11:13:36 -0400
In-Reply-To: <53A05196.60801@oracle.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, 17 Jun 2014, Jeff Liu wrote:

> Date: Tue, 17 Jun 2014 22:32:54 +0800
> From: Jeff Liu <jeff.liu@oracle.com>
> To: Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger@dilger.ca>
> Cc: linux-ext4@vger.kernel.org
> Subject: [PATCH 20/24] ext4: return actual error on ext4_init_fs
> 
> From: Jie Liu <jeff.liu@oracle.com>
> 
> Return the actual error code if call kset_create_and_add() failed

Considering the rest of the series this looks good to me. Thanks!

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

> 
> Cc: Theodore Ts'o <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Signed-off-by: Jie Liu <jeff.liu@oracle.com>
> ---
>  fs/ext4/super.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index b9b9aab..5912193 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -5545,8 +5545,8 @@ static int __init ext4_init_fs(void)
>  	if (err)
>  		goto out6;
>  	ext4_kset = kset_create_and_add("ext4", NULL, fs_kobj);
> -	if (!ext4_kset) {
> -		err = -ENOMEM;
> +	if (IS_ERR(ext4_kset)) {
> +		err = PTR_ERR(ext4_kset);
>  		goto out5;
>  	}
>  	ext4_proc_root = proc_mkdir("fs/ext4", NULL);
> 
