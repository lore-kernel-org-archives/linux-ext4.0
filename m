From: Ric Wheeler <ricwheeler@gmail.com>
Subject: Re: Feature request: e2fsck -z
Date: Wed, 10 Aug 2011 12:06:43 +0100
Message-ID: <4E426643.3050709@gmail.com>
References: <4E4173D4.9010104@zytor.com> <4E422686.8080207@gmail.com> <4420E0D8-5E16-4FD0-A7A9-B462F02D742D@dilger.ca> <4E423FD0.40108@gmail.com> <alpine.LFD.2.00.1108101134580.4380@dhcp-27-109.brq.redhat.com> <82k4ala62o.fsf@mid.bfk.de> <alpine.LFD.2.00.1108101259330.4380@dhcp-27-109.brq.redhat.com> <82fwl9a5o5.fsf@mid.bfk.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Lukas Czerner <lczerner@redhat.com>,
	Andreas Dilger <adilger@whamcloud.com>,
	"H. Peter Anvin" <hpa@zytor.com>, linux-ext4@vger.kernel.org
To: Florian Weimer <fweimer@bfk.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54440 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab1HJLGt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Aug 2011 07:06:49 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so621254wyg.19
        for <linux-ext4@vger.kernel.org>; Wed, 10 Aug 2011 04:06:49 -0700 (PDT)
In-Reply-To: <82fwl9a5o5.fsf@mid.bfk.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 08/10/2011 12:04 PM, Florian Weimer wrote:
> * Lukas Czerner:
>
>> On Wed, 10 Aug 2011, Florian Weimer wrote:
>>
>>> * Lukas Czerner:
>>>
>>>> You're right. It is a part of e2fsck and you can enable it with -E
>>>> discard.
>>> If the block device does not support TRIM, does this result in zeros
>>> being written instead?
>> Of course not, discard works only on devices which does support it. If
>> the device does not support discard it will to nothing.
> Oh, then it doesn't address hpa's use case (improving compression).
>

I think that there are multiple ways to help compression.

One would be to extract only the used data blocks (like file system specific 
dump utilities can do), the other would be to zero with the discard or by 
writing zeros to the unused blocks.

Ric

