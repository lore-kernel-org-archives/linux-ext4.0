From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/12 v2] Moving i_dquot out of struct inode
Date: Fri, 10 Oct 2014 16:54:58 +0200
Message-ID: <1412952910-7142-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
	xfs@oss.sgi.com, cluster-devel@redhat.com,
	Steven Whitehouse <swhiteho@redhat.com>,
	Mark Fasheh <mfasheh@suse.com>,
	Joel Becker <jlbec@evilplan.org>, ocfs2-devel@oss.oracle.com,
	reiserfs-devel@vger.kernel.org, Jeff Mahoney <jeffm@suse.de>,
	Dave Kleikamp <shaggy@kernel.org>,
	jfs-discussion@lists.sourceforge.net, tytso@mit.edu,
	viro@zeniv.linux.org.uk, Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  this patch set moves i_dquot array from struct inode into filesystem private
part of the inode. Thus filesystems which don't need it save 2 pointers in
their inodes (would be 3 after we add project quota support into generic
quota).

I have patches to move inode->i_data.private_list into filesystem private part
of the inode which is going to save another 2 pointers using the same
mechanism. However I didn't want to mix those in.

The patch series also contains a change to quotactl so that each filesystem
can set quota types it supports. This is in the end unrelated change
(originally it was necessary for i_dquot moving but in the end I changed
things so that it's not anymore). I can move that into a separate series
but I was somewhat reluctant to do that since that would mean another 6
one-line patches to the same files we are changing here...

If noone has any objections, I'd like to queue this series into my tree for
the next merge window. For that I'd prefer to get acks from affected fs
maintainers (the changes are pretty trivial and I don't feel it's a must but
still I'd prefer fs maintainers to ack they are aware of the changes).

								Honza

Changes since v1:
* Inode field names are now named enum
* Quota type masks now have names like QTYPE_MASK_{USR|GRP|PRJ} instead of
  opencoding shifts.
