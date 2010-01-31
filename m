From: Thomas Kupper <thomas@kupper.org>
Subject: mount ext2/3 as ext4 - no changes to ext2/3 fs structures?
Date: Sun, 31 Jan 2010 23:31:03 +0100
Message-ID: <88FF0BDF-9F6F-4A2D-A236-C388BFFA145D@kupper.org>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: linux-ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mxout004.mail.hostpoint.ch ([217.26.49.183]:52747 "EHLO
	mxout004.mail.hostpoint.ch" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750940Ab0BAFnO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Feb 2010 00:43:14 -0500
Received: from [10.0.2.20] (helo=asmtp002.mail.hostpoint.ch)
	by mxout004.mail.hostpoint.ch with esmtp (Exim 4.69 (FreeBSD))
	(envelope-from <thomas@kupper.org>)
	id 1Nbp44-000INF-1p
	for linux-ext4@vger.kernel.org; Mon, 01 Feb 2010 06:43:12 +0100
Received: from [144.85.208.28] (helo=supertommbp.lan)
	by asmtp002.mail.hostpoint.ch with esmtpa (Exim 4.69 (FreeBSD))
	(envelope-from <thomas@kupper.org>)
	id 1Nbp43-0003Q9-TR
	for linux-ext4@vger.kernel.org; Mon, 01 Feb 2010 06:43:11 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I guess it's a very simple question which I could not find a clear answer on the net: The ext4 wiki states that since 2.6.29 one can mount ext2/3 as ext4 without any changes.

Consider the following scenario: Assume I have a partition formated with ext2 on a computer with some 2.4.x kernel. Now I mount this ext2 partition on another computer as ext4 using a 2.6.29+ kernel. After that I take the disk back to the older computer and mount the ext2 on the 2.4.x kernel with the ext2 driver.

Does that work? Or is the ext4 driver updating some internal structures in a way that an old ext2 driver can't handle that partition anymore? Assume I  don't enable any ext4 specific features like extents, etc.


Thanks for any clarification or pointing to a doc that does,
Thomas