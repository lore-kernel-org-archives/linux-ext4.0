From: Phillip Susi <psusi@cfl.rr.com>
Subject: 64bit filesystem questions
Date: Thu, 09 Jun 2011 10:36:04 -0400
Message-ID: <4DF0DA54.1080005@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:54621 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab1FIOgH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 9 Jun 2011 10:36:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I was checking up on the support for 64bit ( > 16 TB ) fs support in the 
next branch last night and have a few questions:

1)  Why is blocks_per_group limited to 32k ( more specifically, 8 x 
blocksize )

2)  Why can't 64bit be enabled explicitly ( with -O or -E? ) instead of 
automatically when needed and the enable automatic 64bit setting is in 
mke2fs.conf?

3)  Why does 64bit disable the resize inode?
