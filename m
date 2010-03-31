From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] ext4: group cache is added in
 ext4_mb_discard_preallocations()
Date: Wed, 31 Mar 2010 09:03:56 -0600
Message-ID: <56E2631B-9D71-4B96-9F2C-D469F6994598@sun.com>
References: <p2yac8f92701003300536kd52f7ad0p43755fcc2382423b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: jing zhang <zj.barak@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:53594 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481Ab0CaVpH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Mar 2010 17:45:07 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id o2VLj2RD005301
	for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 14:45:06 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0L0600M001JOBJ00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Wed,
 31 Mar 2010 14:45:02 -0700 (PDT)
In-reply-to: <p2yac8f92701003300536kd52f7ad0p43755fcc2382423b@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-03-30, at 06:36, jing zhang wrote:
> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
> +++ ext4_mm_leak/mballoc-13.c	2010-03-30 20:28:08.000000000 +0800
> @@ -4183,12 +4183,20 @@ static int ext4_mb_discard_preallocation
> 	trace_ext4_mb_discard_preallocations(sb, needed);
> -	for (i = 0; i < ngroups && needed > 0; i++) {
> -		ret = ext4_mb_discard_group_preallocations(sb, i, needed);
> +	if (needed <= 0)
> +		return freed;
> +	for (i = 0; i < ngroups; i++) {
> +		if (grp_cache >= ngroups)
> +			grp_cache -= ngroups;
> +		ret = ext4_mb_discard_group_preallocations(sb, grp_cache, needed);


Anything that is walking every group in the filesystem is going to hit  
problems on large filesystems.  This seems like something that needs  
to be fixed in a different way (e.g. keeping a list of preallocations).

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

