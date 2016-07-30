From: Vegard Nossum <vegard.nossum@oracle.com>
Subject: Re: Open bugs found by fuzzing as of 2016-07-30
Date: Sat, 30 Jul 2016 21:25:15 +0200
Message-ID: <579CFF1B.40201@oracle.com>
References: <579CA5EB.1070707@oracle.com>
 <09df1f58-ed4c-6887-e112-bbc68d9ec1d6@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: nborisov <n.borisov.lkml@gmail.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37757 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbcG3TZW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 30 Jul 2016 15:25:22 -0400
In-Reply-To: <09df1f58-ed4c-6887-e112-bbc68d9ec1d6@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/30/2016 08:39 PM, nborisov wrote:
> On 30.07.2016 16:04, Vegard Nossum wrote:
>> It's been two weeks since I posted the first list of bugs found using
>> AFL: https://www.spinics.net/lists/linux-ext4/msg53022.html
>>
>> With a bunch of ext4 patches going into 4.8 we're down from 15 to 6
>> with current linus/master:
>
> Are the patches going into 4.8 tagged for stable or are they going to go
> just in to 4.8?

It seems that most of them are indeed tagged for stable; for the patches
I submitted or reported for, it looks like the only one without a stable
tag is a warning about large memory allocations -- commit
7bc9491645118c9461bd21099c31755ff6783593.

Keep in mind that these bugs were found by fuzzing/intentional
corruption and so you are unlikely to run into them by chance.


Vegard
