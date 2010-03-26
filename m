From: jing zhang <zj.barak@gmail.com>
Subject: Re: [PATCH] ext4: remove unnecessary operation in
	ext4_mb_normalize_group_request()
Date: Fri, 26 Mar 2010 22:37:49 +0800
Message-ID: <ac8f92701003260737h8e46e69y5a7bd119036ec486@mail.gmail.com>
References: <ac8f92701003250754o682aa32dw9bb51f36f0fa433b@mail.gmail.com>
	 <87wrwzv732.fsf@linux.vnet.ibm.com>
	 <ac8f92701003260644s7dad8b4mea3bcb4dbcedfd17@mail.gmail.com>
	 <87bpebnonl.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	"Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34283 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754035Ab0CZOhu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Mar 2010 10:37:50 -0400
Received: by gyg13 with SMTP id 13so214004gyg.19
        for <linux-ext4@vger.kernel.org>; Fri, 26 Mar 2010 07:37:49 -0700 (PDT)
In-Reply-To: <87bpebnonl.fsf@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2010/3/26, Aneesh Kumar K. V <aneesh.kumar@linux.vnet.ibm.com>:
> On Fri, 26 Mar 2010 21:44:33 +0800, jing zhang <zj.barak@gmail.com> wrote:
>> 2010/3/26, Aneesh Kumar K. V <aneesh.kumar@linux.vnet.ibm.com>:
>> > On Thu, 25 Mar 2010 22:54:21 +0800, jing zhang <zj.barak@gmail.com>
>> > wrote:
>> >> From: Jing Zhang <zj.barak@gmail.com>
>> >>
>> >> Date: Wed Mar 25  22:55:04   2010
>> >>
>> >> Checking bug seems not at right place, and the function itself should
>> >> be inlined.
>> >>
>> >> Cc: Theodore Ts'o <tytso@mit.edu>
>> >> Cc: Andreas Dilger <adilger@sun.com>
>> >> Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
>> >> Cc: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
>> >> Signed-off-by: Jing Zhang <zj.barak@gmail.com>
>> >>
>> >> ---
>> >>
>> >> --- linux-2.6.32/fs/ext4/mballoc.c	2009-12-03 11:51:22.000000000 +0800
>> >> +++ ext4_mm_leak/mballoc-10.c	2010-03-25 22:44:00.000000000 +0800
>> >> @@ -2786,9 +2786,7 @@ out_err:
>> >>  static void ext4_mb_normalize_group_request(struct
>> >> ext4_allocation_context *ac)
>> >>  {
>> >>  	struct super_block *sb = ac->ac_sb;
>> >> -	struct ext4_locality_group *lg = ac->ac_lg;
>> >>
>> >> -	BUG_ON(lg == NULL);
>> >>  	if (EXT4_SB(sb)->s_stripe)
>> >>  		ac->ac_g_ex.fe_len = EXT4_SB(sb)->s_stripe;
>> >>  	else
>> >
>> > That BUG_ON is to ensure that the allocation context is actually having
>> > a locality group which is needed for group allocation request.
>> >
>> > -aneesh
>> >
>>
>> Please check
>> 1, the 3 lines at the end of ext4_mb_group_or_file()
>> 2, the function name of this patch
>>
>
> What i wanted to mention was the BUG_ON is there to ensure that we don't
> call ext4_mb_normalize_group_request on non group enabled allocation
> context by programming mistake. Doing that would cause ac_g_ex.fe_len
> to change. So that BUG_ON is there to capture a programming error.
>
> -aneesh
>

Thank you, Aneesh, for good explanation in patience.

Again, good weekend.

Still in work?

        - zj
