From: Coly Li <coyli@suse.de>
Subject: Re: question about patch queue and ext4-git
Date: Mon, 15 Oct 2007 22:29:23 +0800
Message-ID: <47137943.2000206@suse.de>
References: <4712FC45.8080401@suse.de>	<20071015051005.0865b2a7@gara>	<47136128.5050301@suse.de> <20071015082113.79c8f503@gara>
Reply-To: coyli@suse.de
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:46890 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbXJOO0y (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 15 Oct 2007 10:26:54 -0400
In-Reply-To: <20071015082113.79c8f503@gara>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



Jose R. Santos wrote:
> On Mon, 15 Oct 2007 20:46:32 +0800
> Coly Li <coyli@suse.de> wrote:
> 
>> Thanks for the replying :-)
>>
>> Jose R. Santos wrote:
>>> On Mon, 15 Oct 2007 13:36:05 +0800
>>> Coly Li <coyli@suse.de> wrote:
>>>
>>>> Now in my mind there are several words for ext4 patches, most frequently one are "patch queue".
>>>>
>>>> I see the patches in patch queue from
>>>> http://www2.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/LATEST/broken-out/ .
>>>> Also I confirm some of the patches are in ext4 git tree now, but I am not sure for two questions:
>>>> 1) Whether all the patches are in ext4 git tree ?
>>> Yes, all these patches should be in ext4 git tree.
>>>
>>>> 2) This patch queue is only used to push ext4 patch into upstream ?
>>> The patch queue series is divided into stable and unstable patches.
>>> The stable patches are the one usually the ones used to push back
>>> upstream, while the unstable section has the patches for development
>>> purposes only and are not ready for pushing upstream (and some may
>>> never make it in).
>> How to recognize which patch is stable patch and which one is unstable patch ?
> 
> Look in the series file.  The mark where the stable patches end is
> documented there.
>   
Find it now. Thanks for your explaining :-)

>>>> Also there is a patch-queue git at http://repo.or.cz/w/ext4-patch-queue.git , is it same to the
>>>> patches in http://www2.kernel.org/pub/linux/kernel/people/tytso/ext4-patches/ ?
>>> Same thing bug in git format.  I believe Ted updates his patch queue
>>> from the patches in the git tree repo, so  if you want latest/greatest
>>> the git tree is what you want.
>>>
>>>> Thanks for clarifying :-)
>>>>
>>>>
>>> -JRS
> 
> -JRS

-- 
Coly Li
SuSE PRC Labs
