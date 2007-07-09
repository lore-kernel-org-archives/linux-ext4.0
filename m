From: "Theodore Ts'o" <tytso@mit.edu>
Subject: ext4-patch-queue rebased to 2.6.22
Date: Mon, 09 Jul 2007 13:37:56 -0400
Message-ID: <E1I7xBM-00044G-2v@candygram.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50222 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbXGIRh6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 9 Jul 2007 13:37:58 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Per our discussion on the call, I've moved the fallocate patches back up
to the front of the queue, and rebased the syscall numbers to 2.6.22.
So we're just waiting for Amit to make the minor on-disk format change
Andreas suggested before we push to Linus.

					- Ted
