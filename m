From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Enable delalloc and mballoc by default.
Date: Wed, 24 Oct 2007 23:00:43 +0530
Message-ID: <471F8143.1040605@linux.vnet.ibm.com>
References: <1193244441-10149-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1193244441-10149-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <471F7F41.6080800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:41871 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbXJXRbJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 24 Oct 2007 13:31:09 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp06.au.ibm.com (8.13.1/8.13.1) with ESMTP id l9OHV6jq016046
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 03:31:06 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9OHV7fC2412546
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 03:31:07 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9OHUoJk021894
	for <linux-ext4@vger.kernel.org>; Thu, 25 Oct 2007 03:30:51 +1000
In-Reply-To: <471F7F41.6080800@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> 
>> @@ -1279,6 +1280,9 @@ clear_qf_name:
>>  		case Opt_delalloc:
>>  			set_opt (sbi->s_mount_opt, DELALLOC);
>>  			break;
> 
> If delalloc, mballoc, extents are the new defaults, is there a reason to
> keep them as options?  When would you need to specify -o extents, now,
> for example?  (though my brain is fuzzy today, maybe I'm missing
> something)  If this were not a filesystem ending in "dev" I could see
> keeping it for compatibility with existing fstabs....
> 

Most of the  options have the <option> no<option> pairs. I guess we would
need it so that kernel won't throw the error "Unrecognized mount option "


I am also not sure whether we will have the above patch merged upstream
when we push mballoc and delalloc. 


>> +		case Opt_nodelalloc:
>> +			clear_opt (sbi->s_mount_opt, DELALLOC);
>> +			break;
>>  		case Opt_mballoc:
>>  			set_opt(sbi->s_mount_opt, MBALLOC);
>>  			break;
>> @@ -1824,6 +1828,8 @@ static int ext4_fill_super (struct super_block *sb, void *data, int silent)
>>  	 * User -o noextents to turn it off
>>  	 */
> 
> I'd either update this comment ^^^^ or remove it, I think.
> 
>> 

I will remove it. Anybody reading the kernel code should be able to figure it out.

-aneesh
