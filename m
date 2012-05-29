From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] Avoid deadlock when corrupted directory creates a loop
Date: Tue, 29 May 2012 22:07:43 +0200
Message-ID: <1338322067-17566-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


  Hello,

  Sami Liedes reported a problem that when a accessing a corrupted filesystem
the system deadlocks. The culprit is that the corruption has created a (self-)
loop in the directory hierarchy and thus we deadlock when trying to lock
i_mutex twice.

This patch set attempts at fixing the problem since it seems relatively
straightforward. We teach d_splice_alias() to fail when it would add the second
connected alias to a directory inode and then handle the failure in
filesystems. So far I've taugh ext? filesystems to handle the failure properly
but other filesystems should be similarly trivial. Just I'd like to hear
whether people agree to the general idea of the fix first.

								Honza
