From: Theodore Ts'o <tytso@mit.edu>
Subject: Initial extents support for e2fsprogs
Date: Sun, 16 Sep 2007 22:57:37 -0400
Message-ID: <1189997861181-git-send-email-tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:33739 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751760AbXIQC5s (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Sep 2007 22:57:48 -0400
Received: from root (helo=candygram.thunk.org)
	by thunker.thunk.org with local-esmtps
	(tls_cipher TLS-1.0:RSA_AES_256_CBC_SHA:32)  (Exim 4.50 #1 (Debian))
	id 1IX6xC-0006Ms-AQ
	for <linux-ext4@vger.kernel.org>; Sun, 16 Sep 2007 23:07:18 -0400
Received: from tytso by candygram.thunk.org with local (Exim 4.63)
	(envelope-from <tytso@thunk.org>)
	id 1IX6nt-0003Xq-T3
	for linux-ext4@vger.kernel.org; Sun, 16 Sep 2007 22:57:41 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


For people who are curious about how the extents patch for e2fsprogs
is going, here's what I currently have as a work in progress.  With
this patch, e2fsck will currently correctly handle a valid filesystem
that contains extents, but it's missing a lot of sanity checks.  In
particular, the pass1b code hasn't been enhanced to deal with extents
yet, plus checks to make sure the extent tree are sane are missing.
But it should be enough for people to get the general idea of where
I'm going.

                                                        - Ted
