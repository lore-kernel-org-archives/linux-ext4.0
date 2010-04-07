From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: group cache is added in ext4_mb_discard_preallocations()
Date: Wed, 7 Apr 2010 20:50:52 +0800
Message-ID: <m2yac8f92701004070550zc4b459d3pb33b9d7f5bd875e9@mail.gmail.com>
References: <p2yac8f92701003300536kd52f7ad0p43755fcc2382423b@mail.gmail.com>
	 <20100406183158.GK23670@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	"Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gx0-f217.google.com ([209.85.217.217]:36731 "EHLO
	mail-gx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab0DGMvK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Apr 2010 08:51:10 -0400
Received: by gxk9 with SMTP id 9so629766gxk.8
        for <linux-ext4@vger.kernel.org>; Wed, 07 Apr 2010 05:51:09 -0700 (PDT)
In-Reply-To: <20100406183158.GK23670@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/4/7, tytso@mit.edu <tytso@mit.edu>:
> On Tue, Mar 30, 2010 at 08:36:17PM +0800, jing zhang wrote:
>> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
>> +++ ext4_mm_leak/mballoc-13.c	2010-03-30 20:28:08.000000000 +0800
>> @@ -4183,12 +4183,20 @@ static int ext4_mb_discard_preallocation
>>  	ext4_group_t i, ngroups = ext4_get_groups_count(sb);
>>  	int ret;
>>  	int freed = 0;
>> +	static ext4_group_t grp_cache = 0;
>
> This is a problem right there.  Remember that there could be multiple
> file systems mounted so a static variable is fundamentally flawed.
>

cool, the static in my patch is a fatal error.

          - zj

> In fact, we could have a one filesystem which has more than 3 times
> the number of groups as another file system.  I'll leave it as an
> exercise to a reader why your patch would be fundamentally flawed in
> that case.
>
> The other thing to note is that this case only gets hit if the file
> system is so full that we need to empty preallocations.  So this means
> hitting this case is rare, which raises two questions: (1) is it worth
> it to optimize this case in the first place (is it really that
> expensive to iterate over all the groups to discard the
> preallocations); (2) can we test this case well?
>
> 						- Ted
>
