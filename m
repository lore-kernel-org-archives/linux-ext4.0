From: Theodore Ts'o <tytso@mit.edu>
Subject: e2fsprogs, xfstests git trees pushed
Date: Mon, 15 Dec 2014 14:31:39 -0500
Message-ID: <20141215193139.GA14298@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:57417 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752211AbaLOTbl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Dec 2014 14:31:41 -0500
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Per our concall today, I've pushed out an updated version of e2fsprogs
to git.kernel.org.  Darrick, feel free to go ahead and rebase your
patchbomb against the next branch.

Also, I've pushed out to github
(https://github.com/tytso/xfstests.git) what I plan to be using for
testing ext4 for this development cycle.  It has the latest changes
which Dave Chinner pushed out to git.kernel.org, plus three commits
which have all been sent to the mailing list for review:

Eryu Guan (1):
      generic/299: various fixes

Theodore Ts'o (2):
      common: use mke2fs -F instead of piping in yes
      ext4/308,generic/324: require fallocate support
      
I'm going to be doing a full test cycle before releasing a new
kvm-xfstests VM images, but hopefully that will be coming in the next
day or two.

Cheers,

						- Ted

