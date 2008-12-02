From: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: BUG: scheduling while atomic: kswapd0/273/0x00000002
Date: Tue, 02 Dec 2008 09:29:40 +0900
Message-ID: <49348174.6060304@jp.fujitsu.com>
References: <20081201152656.GB25876@skywalker> <20081201155341.GB2506@balbir.in.ibm.com> <20081201155755.GA30217@skywalker>
Reply-To: toshi.okajima@jp.fujitsu.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54829 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752004AbYLBA3r (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 1 Dec 2008 19:29:47 -0500
Received: from m3.gw.fujitsu.co.jp ([10.0.50.73])
	by fgwmail6.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id mB20Tjd5026134
	for <linux-ext4@vger.kernel.org> (envelope-from toshi.okajima@jp.fujitsu.com);
	Tue, 2 Dec 2008 09:29:45 +0900
Received: from smail (m3 [127.0.0.1])
	by outgoing.m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 6654245DD7D
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 09:29:45 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (s3.gw.fujitsu.co.jp [10.0.50.93])
	by m3.gw.fujitsu.co.jp (Postfix) with ESMTP id 3A82F45DD7B
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 09:29:45 +0900 (JST)
Received: from s3.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id 1C2071DB8038
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 09:29:45 +0900 (JST)
Received: from m105.s.css.fujitsu.com (m105.s.css.fujitsu.com [10.249.87.105])
	by s3.gw.fujitsu.co.jp (Postfix) with ESMTP id BBA901DB803B
	for <linux-ext4@vger.kernel.org>; Tue,  2 Dec 2008 09:29:44 +0900 (JST)
In-Reply-To: <20081201155755.GA30217@skywalker>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Aneesh Kumar K.V wrote:
> On Mon, Dec 01, 2008 at 09:23:41PM +0530, Balbir Singh wrote:
>> * Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com> [2008-12-01 20:56:56]:
>>
>>> Hi,
>>>
>>> With the latest patch queue i am getting the below error
>>>
>> Did you enable jbd_debug enabled by any chance? 
>>
> 
> No. The problem is we cannot call jbd2_log_wait_commit
> from blkdev_releasepage because jbd2_log_wait_commit
> does a wait_event 
> 
> 549                 spin_unlock(&journal->j_state_lock);
> 550                 wait_event(journal->j_wait_done_commit,
> 551                                 !tid_gt(tid, journal->j_commit_sequence));
> 552                 spin_lock(&journal->j_state_lock);
> 
> -aneesh
OK. This problem was caused by the patch which I made.
I will make a patch which fixes it immediately.
Thank you for your report.

Best Regards,
Toshiyuki Okajima

