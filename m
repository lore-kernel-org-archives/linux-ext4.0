From: Alexey Fisher <bug-track@fisher-privat.net>
Subject: one way to dmesg
Date: Wed, 04 Nov 2009 15:26:44 +0100
Message-ID: <1257344804.2852.11.camel@zwerg>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:44973 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756514AbZKDO0l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 4 Nov 2009 09:26:41 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hallo,
this is sort of continue of discussion about unified way to mount fs
readonly.
I wont to know how about dmesg/printk. I see ext[234] produce different
logs on mount even it use same code. I feel like i have some time to
digg in. My target is easy to parse dmesg.
Firs question: is it really important to print function in ext3_warning?
Or is it just ok to do it ext4_msg way?

Alexey

