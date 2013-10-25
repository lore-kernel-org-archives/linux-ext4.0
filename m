From: Andrew Bradford <andrew@bradfordembedded.com>
Subject: e2fsprogs: Why __uint64_t in unix_discard() in lib/ext2fs/unix_io.c?
Date: Fri, 25 Oct 2013 09:54:36 -0400
Message-ID: <526A781C.9090904@bradfordembedded.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:36867 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752573Ab3JYNyj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 25 Oct 2013 09:54:39 -0400
Received: from brick.omni-id.com (unknown [173.225.52.244])
	by mail.messagingengine.com (Postfix) with ESMTPA id EA12AC00E84
	for <linux-ext4@vger.kernel.org>; Fri, 25 Oct 2013 09:54:36 -0400 (EDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

In e2fsprogs commit e90a59ed434d6c5e38dd148aa4ba5b22b8f7eb24 the
unix_discard() function was implemented.  Sorry, I was not subscribed
when that patch went to the list or I would have replied to it.

In unix_discard() in e2fsprogs lib/ext2fs/unix_io.c, starting at line
922 on the current git master branch HEAD, the __uint64_t type is used
for the range[] array which is used to perform an ioctl().
But, the BLKDISCARD ioctl() in the kernel uses uint64_t types to specify
the range.

Why is __uint64_t used in e2fsprogs's unix_discard() function?  It's not
clear to me.  This is the only use of __uint64_t in all of e2fsprogs.

Why wouldn't uint64_t work here?

Thanks,
Andrew
