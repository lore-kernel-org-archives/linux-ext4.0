From: sho@tnes.nec.co.jp
Subject: RE: Updated ext4 patches for 2.6.18-rc6
Date: Fri, 8 Sep 2006 19:17:11 +0900
Message-ID: <20060908191711sho@rifu.tnes.nec.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:24007 "EHLO
	tyo201.gate.nec.co.jp") by vger.kernel.org with ESMTP
	id S1750772AbWIHKRi (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Sep 2006 06:17:38 -0400
Received: from mailgate3.nec.co.jp (mailgate53.nec.co.jp [10.7.69.162] (may be forged))
	by tyo201.gate.nec.co.jp (8.13.8/8.13.4) with ESMTP id k88AHa17020130
	for <linux-ext4@vger.kernel.org>; Fri, 8 Sep 2006 19:17:36 +0900 (JST)
Received: (from root@localhost) by mailgate3.nec.co.jp (8.11.7/3.7W-MAILGATE-NEC)
	id k88AHas05786 for linux-ext4@vger.kernel.org; Fri, 8 Sep 2006 19:17:36 +0900 (JST)
Received: from secsv3.tnes.nec.co.jp (tnesvc2.tnes.nec.co.jp [10.1.101.15]) by mailsv4.nec.co.jp (8.11.7/3.7W-MAILSV4-NEC) with ESMTP
	id k88AHaQ08272 for <linux-ext4@vger.kernel.org>; Fri, 8 Sep 2006 19:17:36 +0900 (JST)
Received: from tnesvc2.tnes.nec.co.jp ([10.1.101.15])
	by secsv3.tnes.nec.co.jp (ExpressMail 5.10) with SMTP
	id 20060908.192045.76502592 for <linux-ext4@vger.kernel.org>
	; Fri, 8 Sep 2006 19:20:45 +0900
To: cmm@us.ibm.com
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Mingming,

I found a trivial bug in Mingming's ext4 patch titled
"ext4-extents-48bit.patch".

There happens a type conflicting:

+int ext4_ext_get_blocks(handle_t *handle, struct inode *inode, ext4_fsblk_t iblock,

You should fix extern declaration for ext4_ext_get_blocks.


Cheers, sho
