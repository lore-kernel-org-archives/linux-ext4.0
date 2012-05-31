From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] mke2fs: enable bigalloc if -C is specified
Date: Thu, 31 May 2012 15:44:42 -0500
Message-ID: <4FC7D83A.40003@redhat.com>
References: <4FC7A1D5.3040805@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756142Ab2EaUoo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 May 2012 16:44:44 -0400
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q4VKihLb022369
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Thu, 31 May 2012 16:44:43 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx12.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id q4VKigT3016569
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-ext4@vger.kernel.org>; Thu, 31 May 2012 16:44:43 -0400
In-Reply-To: <4FC7A1D5.3040805@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/31/12 11:52 AM, Eric Sandeen wrote:
> If -C is specified w/o -O bigalloc it has no effect and generates
> no error.  If a cluster size is specified, that should imply
> bigalloc.

Hm, so should -O bigalloc even be supported (or documented), or should
this always be done via -C XXXX?  It seems better to specify the size
rather than have some other -O option which picks an (arbitrary?) default
of 16x.

I'm also wondering what kind of guidance we should offer for choosing
cluster sizes - or if we should default to a cluster size given either
fs size, inode count, or combinations thereof.

I think the hard cold truth is that ext4 just isn't sufficiently scalable
at larger sizes without a larger cluster size, so I'm inclined to start
thinking about choosing some increasing cluster sizes as defaults, what
do you think?

And finally, is this stuff robust enough to start documenting in
the manpages yet?  I'm not sure the enospc problems have been worked
out yet...

-Eric

> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> ---
> 
> diff --git a/misc/mke2fs.c b/misc/mke2fs.c
> index 7ec8cc2..d1944dc 100644
> --- a/misc/mke2fs.c
> +++ b/misc/mke2fs.c
> @@ -1351,6 +1351,8 @@ profile_error:
>  					optarg);
>  				exit(1);
>  			}
> +			fs_param.s_feature_ro_compat |=
> +					EXT4_FEATURE_RO_COMPAT_BIGALLOC;
>  			break;
>  		case 'D':
>  			direct_io = 1;
> 
> 

