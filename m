From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC][PATCH 2/7]ext4: Add EXT4_IOC_CLR_GLOBAL_ALLOC_RULE	clears
 block allocation restriction
Date: Wed, 24 Jun 2009 01:21:31 +0200
Message-ID: <20090623232131.GO31668@webber.adilger.int>
References: <4A409171.3090202@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:58191 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576AbZFWXVv (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Jun 2009 19:21:51 -0400
Content-disposition: inline
In-reply-to: <4A409171.3090202@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 23, 2009  17:25 +0900, Akira Fujita wrote:
> Block allocation restriction is cleared with this ioctl or umount filesystem.
> 
>  #define EXT4_IOC_CLR_GLOBAL_ALLOC_RULE _IOW('f', 17, struct ext4_alloc_rule);
> 
>   struct ext4_alloc_rule {
>         __u64 start;            /* start physical offset to clear rule */
>         __u64 len;              /* number of blocks to be clear */
>         __u32 alloc_flag;       /* not used, should be zero */
>   };

Why not call EXT4_IOC_ADD_GLOBAL_ALLOC_RULE with a "clear" flag?

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

