From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/3] Fix ext4 deadlock when running xfstests/269
Date: Tue, 10 Dec 2013 11:13:57 +0100
Message-ID: <1386670440-3158-1-git-send-email-jack@suse.cz>
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34166 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752913Ab3LJKOF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Dec 2013 05:14:05 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


  Hello,

  these three patches fix a deadlock Akira-san has been observing for
some time when running xfstest's test 269 for long enough. The first two
patches are preparatory and the third patch fixes the real problem -
calling ext4_should_retry_alloc() from a wrong locking context.

								Honza
