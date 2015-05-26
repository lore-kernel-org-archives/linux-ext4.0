From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4 v2] e2fsprogs: Support for orphan file feature
Date: Tue, 26 May 2015 09:51:04 +0200
Message-ID: <1432626669-6643-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42100 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352AbbEZHvR (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 26 May 2015 03:51:17 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  this is the second version of support for orphan file feature in e2fsprogs.
Since v1, I have finished and debugged e2fsck support, fixed a couple of issues
in mke2fs and tune2fs and also incorporated changes resulting from the review.
The only unresolved issue I'm aware of is which reserved inode will we use for
this feature.

If nobody speaks up, I will pick up patches from Konstantin to support
increasing number of reserved inodes (he implemented it in resize2fs, I will
move it to tune2fs by moving some resize2fs functionality to libext2fs). That
will practically remove the current limitation of the number of reserved
inodes.

								Honza
