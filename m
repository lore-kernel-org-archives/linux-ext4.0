From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] mke2fs: add discard to default mke2fs.conf and disable
 by default
Date: Wed, 17 Apr 2013 15:33:40 -0700
Message-ID: <516F2344.3090507@redhat.com>
References: <516F1C8A.9040702@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966884Ab3DQWdl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Apr 2013 18:33:41 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r3HMXfXe026664
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 17 Apr 2013 18:33:41 -0400
Received: from Liberator-563.local (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id r3HMXfeE012663
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 17 Apr 2013 18:33:41 -0400
In-Reply-To: <516F1C8A.9040702@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 4/17/13 3:04 PM, Eric Sandeen wrote:
> Discard is a very big hammer.  If it succeeds, there's no undo
> or going back; on the other hand, on some devices the giant discard
> issued at mkfs time makes them go offline.  :(
> 
> Although I'm reluctant to waffle back and forth on default behavior,
> I think this disabling it by default the prudent thing to do.
> 
> This patch also adds the discard option into the default mke2fs.conf
> file; although it could be set, it was not in the template.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Sorry, scratch this; it won't work if, say, discard=1 in the conf
file and the user specifies -E nodiscard or -K; it'll turn it back
on after those options are processed, I think.  I'll send another
patch later when I'm not firing it off too quickly from a conference. ;)

-Eric

> ---
> 
> If disabling by default isn't desired, we should at least include
> the mke2fs.conf.in change (set to 1).
> 
> Thanks,
> -Eric
> 
> diff --git a/misc/mke2fs.8.in b/misc/mke2fs.8.in
> index 023ba49..a005eca 100644
> --- a/misc/mke2fs.8.in
> +++ b/misc/mke2fs.8.in
> @@ -277,11 +277,11 @@ Attempt to discard blocks at mkfs time (discarding blocks initially is useful
>  on solid state devices and sparse / thin-provisioned storage). When the device
>  advertises that discard also zeroes data (any subsequent read after the discard
>  and before write returns zero), then mark all not-yet-zeroed inode tables as
> -zeroed. This significantly speeds up filesystem initialization. This is set
> -as default.
> +zeroed. This significantly speeds up filesystem initialization. This is disabled
> +by default.
>  .TP
>  .BI nodiscard
> -Do not attempt to discard blocks at mkfs time.
> +Do not attempt to discard blocks at mkfs time.  This is the default.
>  .TP
>  .BI quotatype
>  Specify which quota type ('usr' or 'grp') is to be initialized. This
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index bbf477a..d723ee7 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -84,7 +84,7 @@ int	cflag;
>  int	verbose;
>  int	quiet;
>  int	super_only;
> -int	discard = 1;	/* attempt to discard device before fs creation */
> +int	discard;	/* attempt to discard device before fs creation? */
>  int	direct_io;
>  int	force;
>  int	noaction;
> diff --git a/misc/mke2fs.conf.in b/misc/mke2fs.conf.in
> index 178733f..db6decb 100644
> --- a/misc/mke2fs.conf.in
> +++ b/misc/mke2fs.conf.in
> @@ -2,6 +2,7 @@
>  	base_features = sparse_super,filetype,resize_inode,dir_index,ext_attr
>  	default_mntopts = acl,user_xattr
>  	enable_periodic_fsck = 0
> +	discard = 0
>  	blocksize = 4096
>  	inode_size = 256
>  	inode_ratio = 16384
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

