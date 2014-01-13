From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [PATCH] ext4.5: remove duplicate .TP in man page
Date: Mon, 13 Jan 2014 11:28:55 -0200
Message-ID: <20140113132854.GB22358@orion.maiolino.org>
References: <1389497099-10546-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30103 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbaAMN3A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Jan 2014 08:29:00 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s0DDSx38024009
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jan 2014 08:29:00 -0500
Received: from orion.maiolino.org (ovpn-113-103.phx2.redhat.com [10.3.113.103])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id s0DDStPw015599
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 13 Jan 2014 08:28:58 -0500
Content-Disposition: inline
In-Reply-To: <1389497099-10546-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Looks good,
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>

On Sat, Jan 11, 2014 at 10:24:59PM -0500, Theodore Ts'o wrote:
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  misc/ext4.5.in | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/misc/ext4.5.in b/misc/ext4.5.in
> index 98494ec..fab1139 100644
> --- a/misc/ext4.5.in
> +++ b/misc/ext4.5.in
> @@ -109,7 +109,6 @@ supported by ext2, ext3, and ext4.
>  This feature enables the storage file type information in directory
>  entries.  This feature is supported by ext2, ext3, and ext4.
>  .TP
> -.TP
>  .B flex_bg
>  .br
>  This ext4 feature allows the per-block group metadata (allocation
> -- 
> 1.8.5.rc3.362.gdf10213
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
