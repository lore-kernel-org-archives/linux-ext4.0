From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] chattr: improve the description for 'j' option in manpage
Date: Wed, 5 Feb 2014 14:55:28 -0200
Message-ID: <20140205165528.GA8749@localhost.localdomain>
References: <1391053576-31308-1-git-send-email-wenqing.lz@taobao.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbaBEQzc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 5 Feb 2014 11:55:32 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s15GtW25001799
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Wed, 5 Feb 2014 11:55:32 -0500
Received: from localhost.localdomain (ovpn-113-131.phx2.redhat.com [10.3.113.131])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id s15GtT0P010013
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Wed, 5 Feb 2014 11:55:31 -0500
Content-Disposition: inline
In-Reply-To: <1391053576-31308-1-git-send-email-wenqing.lz@taobao.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This looks good to me. Consider it 

Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

On Thu, Jan 30, 2014 at 11:46:16AM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> Ext4 file system also supports to set/clear 'j' attribute, but it just
> say that this option is only useful for ext3 in manpage.  This commit
> fixes it.
> 
> Cc: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  misc/chattr.1.in |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/misc/chattr.1.in b/misc/chattr.1.in
> index 932ef4b..2a3640c 100644
> --- a/misc/chattr.1.in
> +++ b/misc/chattr.1.in
> @@ -112,8 +112,8 @@ to the file.  Only the superuser or a process possessing the
>  CAP_LINUX_IMMUTABLE capability can set or clear this attribute.
>  .PP
>  A file with the `j' attribute has all of its data written to the ext3
> -journal before being written to the file itself, if the filesystem is
> -mounted with the "data=ordered" or "data=writeback" options.  When the
> +or ext4 journal before being written to the file itself, if the filesystem
> +is mounted with the "data=ordered" or "data=writeback" options.  When the
>  filesystem is mounted with the "data=journal" option all file data
>  is already journalled and this attribute has no effect.  Only
>  the superuser or a process possessing the CAP_SYS_RESOURCE
> @@ -171,7 +171,7 @@ The `c', 's',  and `u' attributes are not honored
>  by the ext2, ext3, and ext4 filesystems as implemented in the current
>  mainline Linux kernels.
>  .PP
> -The `j' option is only useful if the filesystem is mounted as ext3.
> +The `j' option is only useful if the filesystem is mounted as ext3 or ext4.
>  .PP
>  The `D' option is only useful on Linux kernel 2.5.19 and later.
>  .SH AVAILABILITY
> -- 
> 1.7.9.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
