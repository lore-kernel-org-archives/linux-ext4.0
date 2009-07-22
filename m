From: "Theodore Ts'o" <tytso@mit.edu>
Subject: e2fsprogs.git pu branch rewound/rebased
Date: Wed, 22 Jul 2009 11:56:29 -0400
Message-ID: <E1MTeBB-0000T1-18@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52226 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751586AbZGVP5d (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Jul 2009 11:57:33 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

The e2fsprogs pu branch has again been rewound, and more of the patches
have entered into the "master" and "next" branches.  I've also doing
more clean up of the patches, collapsing patches where they make sense,
and of course the pu branch has been rebased onto the latest "maint"
fixups, in particular to pick up latest fixes from lib/ext2fs/extent.c.

We now have 40 patches still to be merged into master and/or next, down
from an original of around 70 or so.  So, progress.  :-)

     		    	      	      	  - Ted
