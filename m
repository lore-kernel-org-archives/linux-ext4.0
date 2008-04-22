From: Theodore Ts'o <tytso@mit.edu>
Subject: [RFC] Modified flex_bg patches
Date: Tue, 22 Apr 2008 08:46:17 -0400
Message-ID: <1208868379-17580-1-git-send-email-tytso@mit.edu>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:40892 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753193AbYDVMq0 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Apr 2008 08:46:26 -0400
Received: from root (helo=closure.thunk.org)
	by thunker.thunk.org with local-esmtp   (Exim 4.50 #1 (Debian))
	id 1JoHvI-00048j-AK
	for <linux-ext4@vger.kernel.org>; Tue, 22 Apr 2008 08:48:36 -0400
Received: from tytso by closure.thunk.org with local (Exim 4.67)
	(envelope-from <tytso@mit.edu>)
	id 1JoHt5-0004a9-FS
	for linux-ext4@vger.kernel.org; Tue, 22 Apr 2008 08:46:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This is a broken up set of patches replacing the js/flex-bg branch
that I've been including in the pu series.

The main way that they have been simplified is that the BLOCK_UNINIT
flag only gets set on block groups which only contains their own
metadata and nothing else.  That is, if the block group contains
another block group's inode table, et. al, then the BLOCK_UNINIT flag
is disabled.  This is *much* simpler since it means that e2fsck pass 5
isn't forced to try to synthesize the block bitmap for the initial
block groups containing foreign block group's metadata.

I've done basic tests and it seems to do the right thing, but Jose,
please look it over and see what you think.

              	       	    	    	     - Ted


