From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Performance of ext4
Date: Wed, 11 Jun 2008 19:58:53 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0806111937460.3720@diagnostix.dwd.de>
References: <Pine.LNX.4.64.0806110801370.19793@diagnostix.dwd.de>
 <20080611105945.GB9008@skywalker>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from dwdmx4.dwd.de ([141.38.3.230]:35034 "EHLO dwdmx4.dwd.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbYFKT6z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 Jun 2008 15:58:55 -0400
Received: from localhost (localhost [127.0.0.1])
	by node4.dwd.de (Postfix) with ESMTP id 570EC71C43D
	for <linux-ext4@vger.kernel.org>; Wed, 11 Jun 2008 19:58:54 +0000 (UTC)
Received: from localhost ([127.0.0.1])
	by localhost (node4.csg-cluster.lan [127.0.0.1]) (amavisd-new, port 2525)
	with SMTP id 30257-40 for <linux-ext4@vger.kernel.org>;
	Wed, 11 Jun 2008 19:58:54 +0000 (UTC)
In-Reply-To: <20080611105945.GB9008@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, 11 Jun 2008, Aneesh Kumar K.V wrote:

> On Wed, Jun 11, 2008 at 08:02:32AM +0000, Holger Kiehl wrote:
>>
>> 2 years ago I used 2.6.16.8 but the hardware is still the same. So what has
>> happened with the performance of ext4? I noticed that 2 years ago I could
>> use extents+mballoc+delalloc, now there is only extents+mballoc in the
>> current kernels. Could delalloc make the big difference? I saw that
>> in Andrew Morton mm tree delalloc is included. Unfortunately when I tried using
>> 2.6.26-rc2-mm1 a sync would never return and there where lot of other
>> odd things, so I could not do any tests with delalloc.
>
>
> The sync and other related hangs should be fix with the latest patches
> vailable at http://repo.or.cz/w/ext4-patch-queue.git. Using mballoc have
> an impact on CPU utilization because we try to build an in-memory extent
> map of free blocks available in the group. The cold cache run (the first
> run) would take more time because of the time needed to build the extent
> map. So repeating the same test and looking at the numbers would help us
> understand the impact of in-memory extent building code.
>
Not sure if I understand this. I first formated the file system and run the
test three times.

>>
>> So any idea what I am doing wrong or what I could do to improve those numbers?
>> Please CC me since I am not subscribed to the list.
>>
>
> You should be able to apply the patches in the patchqueue mentioned above  to 2.6.26-rc5
> Can you test with the same and get the numbers. ? Also delalloc enabled
> by default with changes from patchqueue force writeback mode for
> journal. So you may want to enable writeback for ext3.
>
Against a clean 2.6.26-rc5 the patchqueue does not apply. Lots of rejects.
The patchqueue also contains changes for defrag that are not in 2.6.26-rc5.
Or did you mean to apply those against the mm tree?

Thanks,
Holger

