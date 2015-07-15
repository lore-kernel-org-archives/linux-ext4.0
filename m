From: Jan Kara <jack@suse.com>
Subject: [PATCH 0/6] quota: Propagate errors when creating quota entry
Date: Wed, 15 Jul 2015 14:42:26 +0200
Message-ID: <1436964152-11203-1-git-send-email-jack@suse.com>
Cc: linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
	Mark Fasheh <mfasheh@suse.com>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net,
	reiserfs-devel@vger.kernel.org, Jan Kara <jack@suse.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  this patch set makes quota code report errors when quota entry creation fails (upto
now such errors were silently ignored). Filesystems can then properly handle the errors
and report them to userspace. Patch set also includes patches to all filesystems to
properly handle the errors. Review by respective fs maintainers is welcome.

If noone objects, I will queue these patches in my tree for the next merge window.

									Honza
