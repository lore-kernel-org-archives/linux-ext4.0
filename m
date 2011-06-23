From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: filesystems bigger than 16 TB?
Date: Thu, 23 Jun 2011 13:35:59 +0200
Message-ID: <4E03251F.4040603@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:60246 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758724Ab1FWLgC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 23 Jun 2011 07:36:02 -0400
Received: from mail.virtall.com (localhost [127.0.0.1])
	by mail.virtall.com (Postfix) with ESMTP id 0C7D43648F0
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jun 2011 13:36:00 +0200 (CEST)
Received: from [192.168.10.145] (e183095092.adsl.alicedsl.de [85.183.95.92])
	by mail.virtall.com (Postfix) with ESMTPSA id B3AB636484B
	for <linux-ext4@vger.kernel.org>; Thu, 23 Jun 2011 13:35:59 +0200 (CEST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

With mkfs.ext4 from 1.41.14, it is not possible to create a filesystem 
which is bigger than 16 TB:


mkfs.ext4: Size of device /dev/sdb too big to be expressed in 32 bits
	using a blocksize of 4096.


But I see it succeeds with the latest git version of e2fsprogs.



The question is: how reliable such a filesystem is?

On a system which is supposed to be reliable, perhaps I'll be better off 
with xfs for such large filesystems?

I'm using Debian Squeeze, which has a 2.6.32 kernel.


-- 
Tomasz Chmielewski
http://wpkg.org
