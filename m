From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: query about truncate and orphan list
Date: Wed, 29 Aug 2012 14:52:22 +0530
Message-ID: <CAOiN93=uvi37EMuOYvd+Nr2up=giPikL+sLEOFTpqOzyHi+Tfw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:38327 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2H2JWX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 29 Aug 2012 05:22:23 -0400
Received: by vcbfk26 with SMTP id fk26so348468vcb.19
        for <linux-ext4@vger.kernel.org>; Wed, 29 Aug 2012 02:22:23 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I have a query about orphan list and truncate.
Currently these steps are performed in ext4_ext_truncate():
a) Start journal handle.
b) add inode to orphan list.
c) i_disksize is updated and inode is mark dirty.
d) actual truncate happen.
e) remove inode from orphan list.
f) handle stop.

If system crash during step d) will i_disksize is actually updated on disk?
AFAIK i_disksize might be updated on the journal but not on its
original location because the transaction is not commited yet.

If this is the case than what is the use of re-starting truncate
operation while processing orphan inode list?

PS: Also, there is function ext4_ext_truncate_extend_restart which may
commit the current transaction
in which case i_disksize would be updated but I am assuming there are
enough free journal blocks.

Thanks,
Ashish
