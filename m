From: Szabolcs Szakacsits <szaka@ntfs-3g.com>
Subject: EXT3: filename duplicates
Date: Thu, 4 Jun 2009 21:39:39 +0300 (EEST)
Message-ID: <Pine.LNX.4.62.0906042111550.22287@tamago.serverit.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from tamago.serverit.net ([91.189.209.155]:46667 "EHLO
	mail.hosting2.serverit.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752822AbZFDTub (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 4 Jun 2009 15:50:31 -0400
Received: from szaka (helo=localhost)
	by mail.hosting2.serverit.net with local-esmtp (Exim 4.63)
	(envelope-from <szaka@ntfs-3g.com>)
	id 1MCHql-00055h-U1
	for linux-ext4@vger.kernel.org; Thu, 04 Jun 2009 21:39:39 +0300
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


Hi,

When testing file creation performance we noticed that sometimes ext3 
getdents64(2) lists some files twice. For instance after creating 
filesnames from 1 to 1000000 in an empty directory:

 find | grep ./976253
 ./976253
 ./976253

This is 100% reproducible. Kernel is 2.6.25.5, x86_64.

Sorry if this was already known and fixed (couldn't find relevant info in 
the archives, changelogs).

Regards,
	   Szaka

--
NTFS-3G: http://ntfs-3g.org
