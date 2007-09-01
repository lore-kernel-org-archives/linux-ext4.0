From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] placate checkpatch.pl to some degree for mballoc.c
Date: Fri, 31 Aug 2007 20:12:59 -0500
Message-ID: <46D8BC9B.8060005@redhat.com>
References: <46D887F2.1040502@redhat.com> <20070831225854.GS5377@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:50180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbXIABNG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 Aug 2007 21:13:06 -0400
In-Reply-To: <20070831225854.GS5377@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Aug 31, 2007  16:28 -0500, Eric Sandeen wrote:
>> Here's a patch for mballoc.c, to make checkpatch happier with it.
>>
>> I was about as pedantic as I could be, except for a few things it 
>> complained about which I just could not agree with. :)
> 
> I'm happy with the changes, since I've adopted the kernel CodingStyle
> as my own, but not everyone at CFS has.
> 

...

>>
>> -Eric
>>
>> Make checkpatch happier with mballoc.c
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> 
> You can add my "Signed-off-by: Andreas Dilger <adilger@clusterfs.com>"
> 
>> @@ -829,7 +845,8 @@ ext4_mb_mark_free_simple(struct super_bl
>> -			mb_clear_bit(first >> min, buddy + sbi->s_mb_offsets[min]);
>> +			mb_clear_bit(first >> min,
>> +					buddy + sbi->s_mb_offsets[min]);
> 
> Hmm, shouldn't "buddy" be aligned on the '(' from the previous line?

...

Yup, I did this a little bit fast & furious; I'll fix those up.

Thanks,

-Eric
