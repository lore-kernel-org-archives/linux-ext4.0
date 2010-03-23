From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: remove unnecessary operation in
 ext4_mb_regular_allocator()
Date: Mon, 22 Mar 2010 21:42:01 -0600
Message-ID: <06B9B10D-6B78-4A44-9DFC-85FD66E8D57B@sun.com>
References: <ac8f92701003220735h76b4a51dib1a9b311f9cf6d99@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42537 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab0CWDmH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Mar 2010 23:42:07 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o2N3g2P5021809
	for <linux-ext4@vger.kernel.org>; Mon, 22 Mar 2010 20:42:04 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KZP00F00TP6KL00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 22 Mar 2010 20:42:02 -0700 (PDT)
In-reply-to: <ac8f92701003220735h76b4a51dib1a9b311f9cf6d99@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-03-22, at 08:35, jing zhang wrote:
> @@ -2027,7 +2027,7 @@ repeat:
>
> 		for (i = 0; i < ngroups; group++, i++) {
> 			struct ext4_group_info *grp;
> -			struct ext4_group_desc *desc;
> +			/* struct ext4_group_desc *desc; */
>
> 			if (group == ngroups)
> 				group = 0;
> @@ -2045,12 +2045,12 @@ repeat:
>
> 			ac->ac_groups_scanned++;
> -			desc = ext4_get_group_desc(sb, group, NULL);
> +			/* desc = ext4_get_group_desc(sb, group, NULL); */
> 			if (cr == 0)
> 				ext4_mb_simple_scan_group(ac, &e4b);
> 			else if (cr == 1 &&


Rather than commenting these lines out, please just delete them.  They  
serve no purpose, and leaving them in the code will just add confusion  
in the future.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

