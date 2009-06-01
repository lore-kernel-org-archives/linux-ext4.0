From: "Theodore Ts'o" <tytso@mit.edu>
Subject: 64-bit e2fsprogs patch rebased against v1.41.6
Date: Mon, 01 Jun 2009 09:44:15 -0400
Message-ID: <E1MB7oF-0007Ot-TB@closure.thunk.org>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:46048 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158AbZFANo0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Jun 2009 09:44:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I've taken the latest 64-bit e2fsprogs patch and rebased them against
v1.41.6.  While I was at it, I also fixed a number of bugs which showed
up when building e2fsprogs on a 32-bit platform and running "make
check".

The patches still need some cleanup before merging with mainline, but
the fact that they've been rebased against v1.41.6 and are now "make
check" clean is a good step forward.

The patch series for the work that I've done can be found here:

 	 git://github.com/tytso/e2fsprogs-64bit.git

... and if Nick or Val or any other ext4 developer anyone would like to
have commit access to the e2fsprogs 64-bit patch queue, just let me know.

I've also made the 64-bit e2fsprogs patches available on the "pu"
(proposed updates) branch of e2fsprogs.  As before, the "pu" branch may
be rewound and rebased without warning, so it's primarily useful for
people to easily get an update to the latest 64-bit patches.  For
collaborative development, it's best to use the e2fsprogs-64bit patch
queue.

I have *not* yet tested these patches on a 64-bit filesystem (mainly
because I'm not set up to easily do that testing at the moment), but it
has all of Nick and Val's patches, only rebased to 1.41.6, so hopefully
it should work.  If folks could try it out and send me feedback, I would
greatly appreciate it.

Thanks!!

						- Ted

