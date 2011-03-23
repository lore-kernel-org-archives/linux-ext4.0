From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: xfstests: failure to umount ext4
Date: Wed, 23 Mar 2011 09:57:52 -0500
Message-ID: <4D8A0A70.9030201@redhat.com>
References: <AANLkTi=NKxmvJx_oEpdeMtfU9ePv4ofG5PjCuh23RJ+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: XFS <xfs@oss.sgi.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932712Ab1CWO6G (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 23 Mar 2011 10:58:06 -0400
In-Reply-To: <AANLkTi=NKxmvJx_oEpdeMtfU9ePv4ofG5PjCuh23RJ+A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/23/11 9:36 AM, Amir Goldstein wrote:
> On Wed, Mar 23, 2011 at 4:03 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>
>> I've been running xfstests on ext4 and I always get annoying failures to umount:
>>
>> 213 8s ... 31s
>> umount: /mnt/test/ext4: device is busy.
>>        (In some cases useful info about processes that use
>>         the device is found by lsof(8) or fuser(1))
>>
>> post 198 mostly fails to umount as well.
>> and post 124 always fails to umount.
>>
>> My server is Ubuntu 10.10, running kernel 2.6.38.
>>
>> Is there any known issue about this? because I could find it on google
>> or on the XFS list.
>>
> 
> Hi All,
> 
> Has anyone seen these failures when running xfstests on ext4?
> My test and scratch partitions are dedicated for xfstests.

I've not seen it, can you investigate with lsof etc?

They both work for me on a quick test, anyway, on a .38
kernel.

What are you using for your partitions under test?
 
-Eric

> Thanks,
> Amir.

