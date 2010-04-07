From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: group cache is added in ext4_mb_discard_preallocations()
Date: Wed, 7 Apr 2010 20:58:36 +0800
Message-ID: <l2jac8f92701004070558l26bcc892g5bb2dbe263e389d5@mail.gmail.com>
References: <p2yac8f92701003300536kd52f7ad0p43755fcc2382423b@mail.gmail.com>
	 <56E2631B-9D71-4B96-9F2C-D469F6994598@sun.com>
	 <h2zac8f92701004010534g3607d64fh2dcf615053e59549@mail.gmail.com>
	 <20100406184952.GM23670@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Andreas Dilger <adilger@sun.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.211.172]:44981 "EHLO
	mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191Ab0DGM6r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Apr 2010 08:58:47 -0400
Received: by ywh2 with SMTP id 2so558248ywh.33
        for <linux-ext4@vger.kernel.org>; Wed, 07 Apr 2010 05:58:46 -0700 (PDT)
In-Reply-To: <20100406184952.GM23670@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/4/7, tytso@mit.edu <tytso@mit.edu>:
> On Thu, Apr 01, 2010 at 08:34:41PM +0800, jing zhang wrote:
>>
>> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
>> +++ ext4_mm_leak/mballoc-14.c	2010-04-01 20:35:58.000000000 +0800
>> @@ -4299,7 +4299,7 @@ repeat:
>>  		}
>>  	} else {
>>  		freed  = ext4_mb_discard_preallocations(sb, ac->ac_o_ex.fe_len);
>> -		if (freed)
>> +		if (freed && freed >= ac->ac_o_ex.fe_len)
>>  			goto repeat;
>>  		*errp = -ENOSPC;
>>  		ac->ac_b_ex.fe_len = 0;
>
> This is just wrong.
>
> Since you didn't give a justification, I'm not sure why you think it
> is correct.
>

Though freed, is the amount freed bigger than needed?
If not, it seems unnecessary to repeat.

      - zj
