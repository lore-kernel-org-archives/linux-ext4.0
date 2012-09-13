From: "norritt" <norritt@t-online.de>
Subject: Re: Ongoing data reorganization/defragmentation?
Date: Thu, 13 Sep 2012 14:20:30 +0200
Message-ID: <5051CF8E.1090000@cube.nornet.local>
References: <5050BA08.80709@bytefortress.de> <080474D2-A9F0-42F2-A114-82766127B7BC@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailout05.t-online.de ([194.25.134.82]:53809 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755004Ab2IMMVQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 13 Sep 2012 08:21:16 -0400
In-Reply-To: <080474D2-A9F0-42F2-A114-82766127B7BC@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12.09.2012 19:35, Andreas Dilger wrote:
> On 2012-09-12, at 10:36, norritt@t-online.de wrote:
>
>> Ongoing data reorganization/defragmentation?
>>
>> So my question is, does ext4 reorganize data when it encounters fragmented files? If so, is there a way to disable that feature which would not do any good on SSDs? Is there anything else to consider when using ext4 on SSDs, except the things I mentioned above?
> No, there is no such background reorganization happening of allocated files. With "delalloc" there is batching of block allocations to try and optimize the initial block selection, but it is static after this time.
>
> Cheers, Andreas
Hi Andreas,

thank you for the quick reply and clearing up the rumours about ext4. 
Its good to know for sure, that ext4 doesn't reorganize data, once it 
has been written to the disk.

Regards Nor
