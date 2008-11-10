From: Norbert Preining <preining@logic.at>
Subject: ext3 aborts journal
Date: Mon, 10 Nov 2008 08:57:04 +0100
Message-ID: <20081110075704.GA31730@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:58761 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbYKJIWm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Nov 2008 03:22:42 -0500
Received: from gamma.logic.tuwien.ac.at ([128.130.175.3] ident=Debian-exim)
	by mx.logic.tuwien.ac.at with esmtps (TLS-1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.63)
	(envelope-from <preining@logic.at>)
	id 1KzRdw-0003fs-HW
	for linux-ext4@vger.kernel.org; Mon, 10 Nov 2008 08:57:04 +0100
Received: from preining by gamma.logic.tuwien.ac.at with local (Exim 4.63)
	(envelope-from <preining@logic.at>)
	id 1KzRdw-0008K0-F0
	for linux-ext4@vger.kernel.org; Mon, 10 Nov 2008 08:57:04 +0100
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

(please Cc)

just a few minutes ago my laptop told me:

[ 4759.267418] __log_wait_for_space: no transactions
[ 4759.267428] Aborting journal on device sda3.
[ 4759.267469] ext3_abort called.
[ 4759.267474] EXT3-fs error (device sda3): ext3_journal_start_sb: Detected aborted journal
[ 4759.267481] Remounting filesystem read-only
[ 4759.267727] journal commit I/O error
[ 4784.453791] Monitor-Mwait will be used to enter C-2 state

That made me a bit nervous. It is with kernel 2.6.28-rc3, now I rebooted
in to -rc4.

Any comments or explanations? Do I have to take any action? Reformat,
...?

Best wishes

Norbert

-------------------------------------------------------------------------------
Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
Debian Developer <preining@debian.org>                         Debian TeX Group
gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
-------------------------------------------------------------------------------
QUALL (vb.)
To speak with the voice of one who requires another to do something
for them.
			--- Douglas Adams, The Meaning of Liff
