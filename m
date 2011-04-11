From: Michael Ubell <ubell@mindspring.com>
Subject: Reads atomic with respect to writes?
Date: Mon, 11 Apr 2011 10:24:22 -0700
Message-ID: <8DD4E915-014E-4D2A-AC59-1347A375C5AA@mindspring.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from elasmtp-masked.atl.sa.earthlink.net ([209.86.89.68]:45678 "EHLO
	elasmtp-masked.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754483Ab1DKRYY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Apr 2011 13:24:24 -0400
Received: from [67.101.147.52] (helo=[10.0.0.110])
	by elasmtp-masked.atl.sa.earthlink.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.67)
	(envelope-from <ubell@mindspring.com>)
	id 1Q9Kqe-0006v2-8K
	for linux-ext4@vger.kernel.org; Mon, 11 Apr 2011 13:24:24 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

POSIX states in http://pubs.opengroup.org/onlinepubs/9699919799/functions/read.html
	I/O is intended to be atomic to ordinary files and pipes and FIFOs. Atomic means that all the bytes from a single operation that started out together end up together, without interleaving from other I/O operations.

Is this supported by the ext4 implementation?

To be more specific:  If I call the read() API with a nbyte value 65536 (at an offset of a multiple of 65536) and at the same time a write() call of 65536 bytes at the same offset is happening will ext4 guarantee that the read will see either the 65536 bytes in the file before the write operation started or the 65536 bytes in the file after the write completed?

Unix file systems have always had this semantic and there are applications which depend on it.


