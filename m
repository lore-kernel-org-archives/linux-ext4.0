From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [PATCH] ext4: fix message in ext4_remount for rw-remount case
Date: Mon, 08 Aug 2011 19:20:58 +0900
Message-ID: <4E3FB88A.7000305@jp.fujitsu.com>
References: <20110801135628.3257a561.toshi.okajima@jp.fujitsu.com> <j1k60i$481$1@dough.gmane.org>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Sergei Zhirikov <sfzhi@yahoo.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51530 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255Ab1HHKUL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Aug 2011 06:20:11 -0400
Received: from m4.gw.fujitsu.co.jp (unknown [10.0.50.74])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id A39D13EE081
	for <linux-ext4@vger.kernel.org>; Mon,  8 Aug 2011 19:20:09 +0900 (JST)
Received: from smail (m4 [127.0.0.1])
	by outgoing.m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 8C31845DE50
	for <linux-ext4@vger.kernel.org>; Mon,  8 Aug 2011 19:20:09 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (s4.gw.fujitsu.co.jp [10.0.50.94])
	by m4.gw.fujitsu.co.jp (Postfix) with ESMTP id 77C8C45DE4E
	for <linux-ext4@vger.kernel.org>; Mon,  8 Aug 2011 19:20:09 +0900 (JST)
Received: from s4.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 61AEEE08001
	for <linux-ext4@vger.kernel.org>; Mon,  8 Aug 2011 19:20:09 +0900 (JST)
Received: from m106.s.css.fujitsu.com (m106.s.css.fujitsu.com [10.240.81.146])
	by s4.gw.fujitsu.co.jp (Postfix) with ESMTP id 2733E1DB802F
	for <linux-ext4@vger.kernel.org>; Mon,  8 Aug 2011 19:20:09 +0900 (JST)
In-Reply-To: <j1k60i$481$1@dough.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi.

(2011/08/07 4:51), Sergei Zhirikov wrote:
> On 2011-08-01 06:56, Toshiyuki Okajima wrote:
>> If there are some inodes in orphan list while a filesystem is being
>> read-only mounted, we should recommend that pepole umount and then
>> mount it when they try to remount with read-write.
> On 2011-08-01 06:56, Toshiyuki Okajima wrote:
>
> Hi,
>
> I have just encountered this feature and I have a question:
>

> How do I umount/mount if it's my root filesystem?
> Is there anything I can do besides "the Microsoft way" (reboot)?
Only way that you can recover this situation by is to reboot
because the root filesystem cannot umount.

Best Regards,
Toshiyuki Okajima


