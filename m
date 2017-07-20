From: Jan Kara <jack@suse.cz>
Subject: [GIT PULL] Various filesystem fixes for 4.13-rc1
Date: Thu, 20 Jul 2017 18:30:29 +0200
Message-ID: <20170720163029.GB23700@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54140 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755297AbdGTQab (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 20 Jul 2017 12:30:31 -0400
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello Linus,

  could you please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git for_linus

to get several ACL related fixes for ext2, reiserfs, and hfsplus. And also
one minor isofs cleanup.

Top of the tree is 84969465ddc4. The full shortlog is:

Ernesto A. Fernández (2):
      ext2: preserve i_mode if ext2_set_acl() fails
      reiserfs: preserve i_mode if __reiserfs_set_acl() fails

Jan Kara (4):
      reiserfs: Don't clear SGID when inheriting ACLs
      ext2: Don't clear SGID when inheriting ACLs
      isofs: Fix off-by-one in 'session' mount option parsing
      hfsplus: Don't clear SGID when inheriting ACLs

The diffstat is

 fs/ext2/acl.c           | 43 +++++++++++++++++++++++++++++--------------
 fs/hfsplus/posix_acl.c  | 30 ++++++++++++++++++------------
 fs/isofs/inode.c        |  8 ++++++--
 fs/reiserfs/xattr_acl.c | 17 +++++++++++------
 4 files changed, 64 insertions(+), 34 deletions(-)

							Thanks
								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
