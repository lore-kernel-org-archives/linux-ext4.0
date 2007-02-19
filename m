From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Updated ext4 patchset: 2.6.20-ext4-2
Date: Sun, 18 Feb 2007 19:37:38 -0500
Message-ID: <E1HIwXC-00006Y-O1@candygram.thunk.org>
Reply-To: linux-ext4@vger.kernel.org
To: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55584 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbXBSAhl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Feb 2007 19:37:41 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


There is a newly updated ext4 patchset available at:

	http://www2.kernel.org/pub/linux/kernel/people/tytso/ext4-patches

and

	http://www2.kernel.org/git/?p=linux/kernel/git/tytso/ext4.git

Compared to 2.6.20-ext4-1, I've removed the the i_version patch, since
they had numerous issues, including not building on ia64.  I've also
added the nanosecond timestamp patch.

Discussion will be happening on the linux-ext4 mailing list.  I plan to
be pushing extent-overlap-bugfix to Linus soon; other patches still need
work before they will be ready.

						- Ted
