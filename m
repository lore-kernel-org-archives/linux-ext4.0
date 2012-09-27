From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: fix potential deadlock in ext4_nonda_switch()
Date: Thu, 27 Sep 2012 16:14:01 -0400
Message-ID: <20120927201401.GA9585@thunk.org>
References: <1348111390-23083-1-git-send-email-tytso@mit.edu>
 <505CE635.6060101@redhat.com>
 <20120921235912.GA27207@thunk.org>
 <87ipaziduh.fsf@openvz.org>
 <20120927180949.GA6862@thunk.org>
 <87fw63ib68.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52746 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753287Ab2I0UOF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 27 Sep 2012 16:14:05 -0400
Content-Disposition: inline
In-Reply-To: <87fw63ib68.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Ah, you're right.  I *can* easily see the problem; somehow I just
didn't notice it, but when I look back at my test logs, it's
definitely there.  I thought sb_start_write() took s_umount, but it
doesn't, because it was trying to solve the exact same lock ordering
problem.  Drat....

Unfortunately, there doesn't seem to be a good solution here.  The two
options I see is either (a) create another version of
writeback_inodes_sb() which doesn't have the WARN_ON check in
fs/fs-writeback.c (the warning is a false positive, since there are
other mechanisms which protect the superblock from being unmounted
while the write system call is in progress), or (b) call
writeback_inodes_sb() out of a workqueue.

		      	       - Ted
