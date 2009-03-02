From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: Re: double free of blocks occurred during online defrag
Date: Mon, 02 Mar 2009 17:30:51 +0900
Message-ID: <49AB993B.8050705@sx.jp.nec.com>
References: <49A4E7B8.2040804@sx.jp.nec.com> <20090225104446.GA25714@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:59839 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbZCBIdz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 Mar 2009 03:33:55 -0500
In-Reply-To: <20090225104446.GA25714@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Aneesh,

Thanks for your reply.

Aneesh Kumar K.V wrote:
> We dropped the patch because I found that the double free in my case was
> not exactly due the explanation given in the patch above.
> 
> I asked to drop the patch in
> 
> http://article.gmane.org/gmane.comp.file-systems.ext4/10199
> 
> I also found that the patch is not completely correct. The meta-data
> blocks which are added to the free_list are not allocated from any
> prealloc space.
> 
> So what you are seeing may be a different problem which the patch is
> hiding from happening.  I guess you will have to look more closely at why the
> double-free is happening in your case.
> 
> -aneesh
> 

I thought that the problem would be solved if we check whether on-disk and buddy
bitmap is different or not when inode prealloc space is released.
However, my understanding was incorrect.
I will continue examining this problem.

Best regards,
Kazuya Mio
