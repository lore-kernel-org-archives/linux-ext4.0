From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] JBD: release checkpoint journal heads through try_to_release_page
 when the memory is exhausted
Date: Tue, 21 Oct 2008 11:49:15 +0900
Message-ID: <48FD432B.80006@jp.fujitsu.com>
References: <20081017.223716.147444348.00960188@stratos.soft.fujitsu.com> <20081020160249.ff41f762.akpm@linux-foundation.org>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, sct@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45842 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213AbYJUCtV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Oct 2008 22:49:21 -0400
Received: from m2.gw.fujitsu.co.jp ([10.0.50.72])
	by fgwmail6.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id m9L2nJq3031207
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Tue, 21 Oct 2008 11:49:20 +0900
Received: from smail (m2 [127.0.0.1])
	by outgoing.m2.gw.fujitsu.co.jp (Postfix) with ESMTP id ADE4F1B801E
	for <linux-ext4@vger.kernel.org>; Tue, 21 Oct 2008 11:49:19 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m2.gw.fujitsu.co.jp (Postfix) with ESMTP id 598612DC01F
	for <linux-ext4@vger.kernel.org>; Tue, 21 Oct 2008 11:49:19 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 3B26F1DB8037
	for <linux-ext4@vger.kernel.org>; Tue, 21 Oct 2008 11:49:19 +0900 (JST)
Received: from ml11.s.css.fujitsu.com (ml11.s.css.fujitsu.com [10.249.87.101])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id E23E21DB803A
	for <linux-ext4@vger.kernel.org>; Tue, 21 Oct 2008 11:49:18 +0900 (JST)
In-Reply-To: <20081020160249.ff41f762.akpm@linux-foundation.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Andrew.
Thank you for your comment.

Andrew Morton wrote:
> On Fri, 17 Oct 2008 22:37:16 +0900 (JST)
> Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com> wrote:
> 
>> Hi.
>>
>> I found the situation where OOM-Killer happens easily.
>> I will inform you of it. 
>> I tried to fix this problem to make OOM-Killer not happen easily as much as 
>> possible.
<SNIP>
> OK.
> 
>> ---
>>  fs/buffer.c                 |   23 ++++++++++++++++++++++-
>>  fs/jbd/journal.c            |    7 +++++++
>>  fs/jbd/transaction.c        |   39 +++++++++++++++++++++++++++++++++++++++
>>  include/linux/buffer_head.h |    7 +++++++
>>  include/linux/jbd.h         |    1 +
>>  5 files changed, 76 insertions(+), 1 deletion(-) 
> 
> The patch is fairly complex, and increasing the buffer_head size can be
Yes.
Applying this fix causes the buffer_head size to increase.
The increase of the buffer_head size changes into 60 bytes from 56 bytes
on x86 system.
As a result, the maximum number of buffer heads of one slab changes
into 63 from 64.
(The increase of the size is less than 2%.)
Therefore I think this change influences system performance hardly.
And I rather want to add a new member because I think it is useful for
not only this fix but also the future.

> rather costly.  An alternative might be to implement a shrinker
> callback function for the journal_head slab cache.  Did you consider
> this?
Yes.
But the unused-list and counters are required by managing the shrink targets
("journal head") if we implement a shrinker.
I thought that comparatively big code changes were necessary for jbd
to accomplish it.

However I will try it.

Best Regards,
Toshiyuki Okajima

