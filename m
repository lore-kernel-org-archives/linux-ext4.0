From: Akira Fujita <a-fujita@rs.jp.nec.com>
Subject: Re: Problems with Online Defragmentation (was: Re: bugs of Online
 Defragmentation)
Date: Wed, 24 Dec 2008 11:43:28 +0900
Message-ID: <4951A1D0.3060502@rs.jp.nec.com>
References: <494F277B.3080902@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Zhang Xiliang <zhangxiliang@cn.fujitsu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:41107 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYLXCnd (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Dec 2008 21:43:33 -0500
In-Reply-To: <494F277B.3080902@cn.fujitsu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,
Zhang Xiliang wrote:
> Hi,
> 
> I tested Online Defrag by using the new code.
> When I have space left which is less than 40M, I can't use e4defrag 
> function.
> 
> Does the Online Defragmentation need some space left which is greater 
> than a value? 40M?
> 

Yes.  Ext4 online defrag needs more than the target file size.
In this case, your file size might be greater than left space.

If you failed in defrag, -v option might be helpful
to find the reason as follows:

[root@bsd086 KERN]# ./e4defrag -v /mnt/mp1/file1
ext4 defragmentation for /mnt/mp1/file1
[1/1] "/mnt/mp2/WORK/file1"
     Defrag size is larger than FileSystem's free space        [ NG ]
  Success:            [0/1]

Regards,
Akira Fujita

