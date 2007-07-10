From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [EXT4 set 1][PATCH 1/2] Add noextents mount option
Date: Tue, 10 Jul 2007 16:30:12 -0700
Message-ID: <20070710163012.6e0ded75.akpm@linux-foundation.org>
References: <1183275348.4010.118.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1183275348.4010.118.camel@localhost.localdomain>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 01 Jul 2007 03:35:48 -0400
Mingming Cao <cmm@us.ibm.com> wrote:

> Add a mount option to turn off extents.

Please update the changelog to describe the reason for making this change.


> Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> ---
> Index: linux-2.6.22-rc4/fs/ext4/super.c
> ===================================================================
> --- linux-2.6.22-rc4.orig/fs/ext4/super.c	2007-06-11 17:02:18.000000000 -0700
> +++ linux-2.6.22-rc4/fs/ext4/super.c	2007-06-11 17:02:22.000000000 -0700
> @@ -725,7 +725,7 @@
>  	Opt_usrjquota, Opt_grpjquota, Opt_offusrjquota, Opt_offgrpjquota,
>  	Opt_jqfmt_vfsold, Opt_jqfmt_vfsv0, Opt_quota, Opt_noquota,
>  	Opt_ignore, Opt_barrier, Opt_err, Opt_resize, Opt_usrquota,
> -	Opt_grpquota, Opt_extents,
> +	Opt_grpquota, Opt_extents, Opt_noextents,
>  };
>  
>  static match_table_t tokens = {
> @@ -776,6 +776,7 @@
>  	{Opt_usrquota, "usrquota"},
>  	{Opt_barrier, "barrier=%u"},
>  	{Opt_extents, "extents"},
> +	{Opt_noextents, "noextents"},
>  	{Opt_err, NULL},
>  	{Opt_resize, "resize"},
>  };
> @@ -1111,6 +1112,9 @@
>  		case Opt_extents:
>  			set_opt (sbi->s_mount_opt, EXTENTS);
>  			break;
> +		case Opt_noextents:
> +			clear_opt (sbi->s_mount_opt, EXTENTS);
> +			break;
>  		default:
>  			printk (KERN_ERR
>  				"EXT4-fs: Unrecognized mount option \"%s\" "
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
