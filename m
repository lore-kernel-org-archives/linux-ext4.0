From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: ext4 online defrag status?
Date: Sun, 21 Nov 2010 20:33:59 +0100
Message-ID: <4CE97427.1090700@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:47966 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753290Ab0KUTeV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 21 Nov 2010 14:34:21 -0500
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 17960359D94
	for <linux-ext4@vger.kernel.org>; Sun, 21 Nov 2010 20:34:18 +0100 (CET)
Received: from [192.168.10.145] (e183095092.adsl.alicedsl.de [85.183.95.92])
	by mail.virtall.com (Postfix) with ESMTPSA id 50A07359D59
	for <linux-ext4@vger.kernel.org>; Sun, 21 Nov 2010 20:34:10 +0100 (CET)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was wondering what is the status of online defragment for ext4?


Generally, fragmentation isn't a big problem with every day usage, but 
can bite when virtual machine (i.e. KVM) disk images are files.

For example:

vm-111-disk-1.raw: 28054 extents found, perfection would be 138 extents


There have been some ext4 defrag patches posted in 2008 and 2009 - what 
is the state of this now in late 2010?



-- 
Tomasz Chmielewski
http://wpkg.org
