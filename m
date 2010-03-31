From: Surbhi Palande <Surbhi.Palande@canonical.com>
Subject: question on sync()
Date: Wed, 31 Mar 2010 19:29:17 +0300
Message-ID: <1270052957.26517.24.camel@subu>
Reply-To: Surbhi.Palande@canonical.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from adelie.canonical.com ([91.189.90.139]:44443 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757620Ab0CaQ3S (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Mar 2010 12:29:18 -0400
Received: from hutte.canonical.com ([91.189.90.181])
	by adelie.canonical.com with esmtp (Exim 4.69 #1 (Debian))
	id 1Nx0n7-0001XZ-2I
	for <linux-ext4@vger.kernel.org>; Wed, 31 Mar 2010 17:29:17 +0100
Received: from a88-112-254-38.elisa-laajakaista.fi ([88.112.254.38] helo=[192.168.1.38])
	by hutte.canonical.com with esmtpsa (TLS-1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <Surbhi.Palande@canonical.com>)
	id 1Nx0n6-0001tS-Tx
	for linux-ext4@vger.kernel.org; Wed, 31 Mar 2010 17:29:17 +0100
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hie,

While looking at fs/sync.c :: sync(), I found out that:

1) sync() first calls wakeup_flusher_threads() which ultimately calls
bdi_alloc_queue_work() with WB_SYNC_NONE for every bdi in the bdi_list.

2) sync() immediate then calls sync_filesystems(0) which does the same
thing - it calls writeback_inodes_sb() which finally calls
bdi_alloc_queue_work() with WB_SYNC_NONE for every bdi corresponding to
every filesystem.

If it is possible, then I wanted to know why there are effectively two
calls which ultimately call bdi_alloc_queue_work() with WB_SYNC_NONE
twice?

Thanks!

Warm Regards,
Surbhi.




