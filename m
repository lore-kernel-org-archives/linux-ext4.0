From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [PATCH] e2fsprogs: Fix how we treat user-spcified filesystem
 size
Date: Wed, 02 Feb 2011 10:05:15 -0800
Message-ID: <4D499CDB.80107@oracle.com>
References: <1296587912-16756-1-git-send-email-lczerner@redhat.com> <140BFB14-31E6-4E76-B1DA-5CD8F54FDD5B@dilger.ca> <AANLkTimRMnceeWpTy6A3h_pEYLq_meAwjOHNOojmhuJR@mail.gmail.com> <alpine.LFD.2.00.1102021048230.3559@dhcp-lab-213.englab.brq.redhat.com> <AANLkTi=5QWtEc+mRnveErm1AE4oLZAZwGOmLP69cx2dx@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>,
	Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:49905 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab1BBSGe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 2 Feb 2011 13:06:34 -0500
In-Reply-To: <AANLkTi=5QWtEc+mRnveErm1AE4oLZAZwGOmLP69cx2dx@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 02/02/2011 09:56 AM, Greg Freemyer wrote:
>> Right, that's why there is the "rant" about it being called kilobytes,
>> but still treated as binary, not decimal unit. But Andreas is right
>> that it is not necessary to have one paragraph grumbling about the
>> stupid-sounding kibibytes and so on.
>>
>> So, what I am going to do is to cope with the standard and use those
>> stupid-sounding binary prefixes (kibi- etc.), remove the "rant" and add
>> one line note for people to be really sure that it is meant to be a
>> binary unit.
>>
>> Thanks!
>> -Lukas
> Lukas,
>
> I'm glad you did that.  I see too often:
>
> Fdisk is broken, I can only put a 150 gigabyte partition on my 160
> gigabyte drive.
>
> Hopefully people will realize the difference when they see its a 150
> Gibibyte partition on a 160 Gigabyte drive.

That's wishful thinking.
