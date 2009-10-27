From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: journaled quota file question
Date: Tue, 27 Oct 2009 03:14:45 +0300
Message-ID: <871vkpwv4a.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.2ka.mipt.ru ([194.85.80.4]:50557 "EHLO mail.2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754722AbZJ0AOj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Oct 2009 20:14:39 -0400
Received: from dmon-lp ([unknown] [10.55.92.161])
 by mail.2ka.mipt.ru (Sun Java(tm) System Messaging Server 7u2-7.02 64bit
 (built Apr 16 2009)) with ESMTPA id <0KS500MG7A35M750@mail.2ka.mipt.ru> for
 linux-ext4@vger.kernel.org; Tue, 27 Oct 2009 02:18:44 +0300 (MSK)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

While looking to ext3/4 quota code I'm wondering
Why do we have to place journaled quota file on fs root?
In some situations it may be useful to place it deeper for example:
/root/dir/quota_file
The only reason what comes in to my mind is that some one
may rename parent folder rename("/root/dir", "/root/dir2")
Is this the only reason?

