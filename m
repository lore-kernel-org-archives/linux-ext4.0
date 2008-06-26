From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: (take 2)[PATCH] JBD: positively dispose the unmapped data buffers
 in journal_commit_transaction
Date: Thu, 26 Jun 2008 15:16:41 +0900
Message-ID: <48633449.6060900@jp.fujitsu.com>
References: <485F8263.8000103@jp.fujitsu.com> <20080623192731.baf0904a.akpm@linux-foundation.org> <4860A9E8.9090103@jp.fujitsu.com> <4861F4BF.5060408@jp.fujitsu.com> <20080625203922.GA8711@atrey.karlin.mff.cuni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46111 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbYFZGRI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 26 Jun 2008 02:17:08 -0400
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id m5Q6H5nN008419
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Thu, 26 Jun 2008 15:17:05 +0900
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id AF5111B801E
	for <linux-ext4@vger.kernel.org>; Thu, 26 Jun 2008 15:17:05 +0900 (JST)
Received: from s10.gw.fujitsu.co.jp (s10.gw.fujitsu.co.jp [10.0.50.80])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 8CC372DC01D
	for <linux-ext4@vger.kernel.org>; Thu, 26 Jun 2008 15:17:05 +0900 (JST)
Received: from s10.gw.fujitsu.co.jp (s10 [127.0.0.1])
	by s10.gw.fujitsu.co.jp (Postfix) with ESMTP id 7A1E3161C00B
	for <linux-ext4@vger.kernel.org>; Thu, 26 Jun 2008 15:17:05 +0900 (JST)
Received: from fjm504.ms.jp.fujitsu.com (fjm504.ms.jp.fujitsu.com [10.56.99.80])
	by s10.gw.fujitsu.co.jp (Postfix) with ESMTP id 1728C161C007
	for <linux-ext4@vger.kernel.org>; Thu, 26 Jun 2008 15:17:05 +0900 (JST)
Received: from fjmscan502.ms.jp.fujitsu.com (fjmscan502.ms.jp.fujitsu.com [10.56.99.142])by fjm504.ms.jp.fujitsu.com with ESMTP id m5Q6GogB028879
	for <linux-ext4@vger.kernel.org>; Thu, 26 Jun 2008 15:16:50 +0900
Received: from [127.0.0.1] ([10.124.101.92])
	by fjmscan502.ms.jp.fujitsu.com (8.13.1/8.12.11) with ESMTP id m5Q6Gnhm006897
	for <linux-ext4@vger.kernel.org>; Thu, 26 Jun 2008 15:16:50 +0900
In-Reply-To: <20080625203922.GA8711@atrey.karlin.mff.cuni.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

Jan Kara wrote:
>   Hi,
> 
>> I updated my patch and introduction article for it by reflecting
>> the comment of Andrew's.
<SNIP>
>>
>> Signed-off-by: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
>   I agree with the change. It's true that we can leave some anonymous
> pages behind and it's nicer to the MM to release them earlier when we
> know they will be never needed again. The patch looks fine to me, you
> can add
>   Acked-by: Jan Kara <jack@suse.cz>

Thank you for confirming.

>   How much have you stressed the patched kernel? I suggest you use
> fsxlinux and put some memory pressure to the system...

I have stressed it for 72 or more hours.
Stresser does:
  - allocates/frees big memory(1.7GB) which was almost system
    memory size(2GB) repeatedly.
Confirmation of integrity of patched Filesystem(jbd) does:
  - creates files, and copies 3 files from created each file
    (3 copies run concurrently), and confirms whether there is
    no difference between created files and copied files.
  (20 processes runs these works concurrently and repeatedly.)
Above 2 jobs run concurrently.

I haven't ever used 'fsxlinux'.
Next time, I will use it.

Thanks,
---
Toshiyuki Okajima

