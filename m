From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH 2/2] e2fsprogs: enable user namespace xattrs by default
Date: Wed, 16 Feb 2011 13:27:39 -0600
Message-ID: <4D5C252B.2010102@redhat.com>
References: <4D5C1380.2020602@redhat.com> <4D5C15C6.5000802@redhat.com> <C637E27A-6E13-4950-B4CC-0451FDB421B9@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab1BPT1l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 16 Feb 2011 14:27:41 -0500
In-Reply-To: <C637E27A-6E13-4950-B4CC-0451FDB421B9@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2/16/11 1:15 PM, Andreas Dilger wrote:
> On 2011-02-16, at 11:21, Eric Sandeen wrote:
>> User namespace xattrs are generally useful, and I think extN
>> is the only filesystem requiring a special mount option to
>> enable them, when xattrs are otherwise available.  So this
>> change sets that mount option into the defaults.
>>
>> Note that if xattrs are config'd off, this will lead to a
>> mostly-harmless:
>>
>>   EXT4-fs (sdc1): (no)user_xattr options not supported
>>
>> message at mount time... 
> 
> Wouldn't it be more useful to change this in the kernel, instead of only changing it in the superblock for new filesystems?
> 
> Cheers, Andreas

I thought about that; maybe it should happen in both places?

-Eric
