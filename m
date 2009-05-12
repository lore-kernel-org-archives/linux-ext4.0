From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/6] Patch series to simplify the ext4_*get_block*() functions
Date: Tue, 12 May 2009 18:48:46 -0400
Message-ID: <1242168532-1063-1-git-send-email-tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:44293 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbZELWs4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 12 May 2009 18:48:56 -0400
Received: from root (helo=closure.thunk.org)
	by thunker.thunk.org with local-esmtp   (Exim 4.50 #1 (Debian))
	id 1M40mN-00085x-TX
	for <linux-ext4@vger.kernel.org>; Tue, 12 May 2009 18:48:56 -0400
Received: from tytso by closure.thunk.org with local (Exim 4.69)
	(envelope-from <tytso@mit.edu>)
	id 1M40mK-0000IO-K2
	for linux-ext4@vger.kernel.org; Tue, 12 May 2009 18:48:52 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The block allocation functions can use a huge amount of cleanup to
make them more understandable.  This is just a starting point to make
life easier.

						- Ted

