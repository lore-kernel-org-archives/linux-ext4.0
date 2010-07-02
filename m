From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 1/8] ext4: clean up ext4_abort() so __func__ is now implicit
Date: Fri,  2 Jul 2010 14:46:52 -0400
Message-ID: <1278096418-14184-2-git-send-email-tytso@mit.edu>
References: <1278096418-14184-1-git-send-email-tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:52309 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759775Ab0GBSrB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 2 Jul 2010 14:47:01 -0400
Received: from root (helo=closure.thunk.org)
	by thunker.thunk.org with local-esmtp   (Exim 4.50 #1 (Debian))
	id 1OUlGN-0008TD-Em
	for <linux-ext4@vger.kernel.org>; Fri, 02 Jul 2010 14:46:59 -0400
Received: from tytso by closure.thunk.org with local (Exim 4.71)
	(envelope-from <tytso@thunk.org>)
	id 1OUlGM-0003hK-Fv
	for linux-ext4@vger.kernel.org; Fri, 02 Jul 2010 14:46:58 -0400
In-Reply-To: <1278096418-14184-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

