From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH] VFS: Handle lazytime in do_mount()
Date: Fri, 17 Nov 2017 06:09:21 -0600
Message-ID: <ee6a6760-a0be-c066-2bcb-39ffacafa4c1@suse.de>
References: <20171011050131.GB13028@x4>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Lukas Czerner <lczerner@redhat.com>
To: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35405 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932562AbdKQMJ0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 17 Nov 2017 07:09:26 -0500
In-Reply-To: <20171011050131.GB13028@x4>
Content-Language: en-US
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



On 10/11/2017 12:01 AM, Markus Trippelsdorf wrote:
> Since commit e462ec50cb5fa ("VFS: Differentiate mount flags (MS_*) from
> internal superblock flags") the lazytime mount option doesn't get passed
> on anymore.
> 
> Fix the issue by handling the option in do_mount().
> 
> Reviewed-by: Lukas Czerner <lczerner@redhat.com>
> Signed-off-by: Markus Trippelsdorf <markus@trippelsdorf.de>

Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

> ---
>  fs/namespace.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 54059b142d6b..b633838b8f02 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -2823,7 +2823,8 @@ long do_mount(const char *dev_name, const char __user *dir_name,
>  			    SB_MANDLOCK |
>  			    SB_DIRSYNC |
>  			    SB_SILENT |
> -			    SB_POSIXACL);
> +			    SB_POSIXACL |
> +			    SB_LAZYTIME);
>  
>  	if (flags & MS_REMOUNT)
>  		retval = do_remount(&path, flags, sb_flags, mnt_flags,
> 

-- 
Goldwyn
