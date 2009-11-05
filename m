From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] make unified logs on ext2
Date: Wed, 04 Nov 2009 21:50:57 -0700
Message-ID: <0EAA3AC5-9EB3-4547-AA50-0B601665B1C3@sun.com>
References: <200911041939.57795.fabian-buettner@gmx.de>
 <4AF1D42A.6000304@redhat.com> <1257367200.4732.6.camel@zwerg>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Alexey Fisher <bug-track@fisher-privat.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62321 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbZKEEux (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 4 Nov 2009 23:50:53 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id nA54owuW008948
	for <linux-ext4@vger.kernel.org>; Wed, 4 Nov 2009 20:50:58 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KSM00100DCKID00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Wed,
 04 Nov 2009 20:50:58 -0800 (PST)
In-reply-to: <1257367200.4732.6.camel@zwerg>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2009-11-04, at 13:40, Alexey Fisher wrote:
> i trying to make messages produced by ext2 more unified. It should be
> easy to parse.

This patch follows the ext4_msg() changes in ext4, so at least it is
not inventing something different.

Reviewed-by: Andreas Dilger <adilger@sun.com>

Minor note:
> @@ -840,8 +858,9 @@ static int ext2_fill_super(struct super_block  
> *sb, void  *data, int silent)
>  	    (EXT2_HAS_COMPAT_FEATURE(sb, ~0U) ||
>  	     EXT2_HAS_RO_COMPAT_FEATURE(sb, ~0U) ||
>  	     EXT2_HAS_INCOMPAT_FEATURE(sb, ~0U)))
> -		printk("EXT2-fs warning: feature flags set on rev 0 fs, "
> -		       "running e2fsck is recommended\n");
> +		 ext2_msg(sb, KERN_WARNING,
> +			"warning: feature flags set on rev 0 fs, "
> +			"running e2fsck is recommended");

It looks like you have an extra space before the ext2_msg() here.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

