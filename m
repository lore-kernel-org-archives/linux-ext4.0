From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [Bug 32482] "htree_dirblock_to_tree:586: inode 260099: block
 1056737" message after every boot
Date: Sat, 2 Apr 2011 23:01:04 -0400
Message-ID: <20110403030104.GA20349@thunk.org>
References: <bug-32482-13602@https.bugzilla.kernel.org/>
 <201104020758.p327wAMh010746@demeter1.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: egokillsall@gmail.com, bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:55972 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757596Ab1DCDBJ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Apr 2011 23:01:09 -0400
Content-Disposition: inline
In-Reply-To: <201104020758.p327wAMh010746@demeter1.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This message will get reset if you use the e2fsck from e2fsprogs
1.41.13 or later.  I recommend using e2fsprogs 1.41.14.

You can translate the "initial error" and "last error" time stamps in
the kernel messages here:

kernel: EXT4-fs (sda10): error count: 5
kernel: EXT4-fs (sda10): initial error at 1301325048: htree_dirblock_to_tree:586: inode 260099: block 1056737
kernel: EXT4-fs (sda10): last error at 1301325083: htree_dirblock_to_tree:586:
inode 260099: block 1056737

via the date command:

% date --date=@1301325048
Mon Mar 28 11:10:48 EDT 2011

% date --date=@1301325083
Mon Mar 28 11:11:23 EDT 2011

(We use seconds since the epoch because we don't want to put time zone
conversion routines in the kernel.)

In any case, it's not a big deal, and you can fix this easily by
upgrading to a newer version of e2fsprogs.

							- Ted
