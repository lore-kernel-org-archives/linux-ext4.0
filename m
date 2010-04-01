From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: group cache is added in ext4_mb_discard_preallocations()
Date: Thu, 1 Apr 2010 20:34:41 +0800
Message-ID: <h2zac8f92701004010534g3607d64fh2dcf615053e59549@mail.gmail.com>
References: <p2yac8f92701003300536kd52f7ad0p43755fcc2382423b@mail.gmail.com>
	 <56E2631B-9D71-4B96-9F2C-D469F6994598@sun.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47460 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756086Ab0DAMen (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 1 Apr 2010 08:34:43 -0400
Received: by gyg13 with SMTP id 13so422520gyg.19
        for <linux-ext4@vger.kernel.org>; Thu, 01 Apr 2010 05:34:42 -0700 (PDT)
In-Reply-To: <56E2631B-9D71-4B96-9F2C-D469F6994598@sun.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/3/31, Andreas Dilger <adilger@sun.com>:
> On 2010-03-30, at 06:36, jing zhang wrote:
>> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
>> +++ ext4_mm_leak/mballoc-13.c	2010-03-30 20:28:08.000000000 +0800
>> @@ -4183,12 +4183,20 @@ static int ext4_mb_discard_preallocation
>> 	trace_ext4_mb_discard_preallocations(sb, needed);
>> -	for (i = 0; i < ngroups && needed > 0; i++) {
>> -		ret = ext4_mb_discard_group_preallocations(sb, i, needed);
>> +	if (needed <= 0)
>> +		return freed;
>> +	for (i = 0; i < ngroups; i++) {
>> +		if (grp_cache >= ngroups)
>> +			grp_cache -= ngroups;
>> +		ret = ext4_mb_discard_group_preallocations(sb, grp_cache, needed);
>
>
> Anything that is walking every group in the filesystem is going to hit
> problems on large filesystems.  This seems like something that needs
> to be fixed in a different way (e.g. keeping a list of preallocations).
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>

Then please take the following also into consideration.

Thanks
            - zj

---

--- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
+++ ext4_mm_leak/mballoc-14.c	2010-04-01 20:35:58.000000000 +0800
@@ -4299,7 +4299,7 @@ repeat:
 		}
 	} else {
 		freed  = ext4_mb_discard_preallocations(sb, ac->ac_o_ex.fe_len);
-		if (freed)
+		if (freed && freed >= ac->ac_o_ex.fe_len)
 			goto repeat;
 		*errp = -ENOSPC;
 		ac->ac_b_ex.fe_len = 0;
