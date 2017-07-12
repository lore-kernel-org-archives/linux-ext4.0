From: Ernesto =?utf-8?Q?A=2E_Fern=C3=A1ndez?=
        <ernesto.mnd.fernandez@gmail.com>
Subject: [PATCH 0/5] Failure to set acl may alter group permissions
Date: Wed, 12 Jul 2017 06:53:22 -0300
Message-ID: <cover.1499805484.git.ernesto.mnd.fernandez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
To: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Dave Kleikamp <shaggy@kernel.org>, linux-ext4@vger.kernel.org,
        jfs-discussion@lists.sourceforge.net,
        reiserfs-devel@vger.kernel.org
Return-path: <reiserfs-devel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: reiserfs-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When changing a file's acl mask, the function that sets the access control
list (ext2_set_acl(), __ext4_set_acl(), __jfs_set_acl()...) will first set
the group permission bits of the file to the value of the mask (by calling
posix_acl_update_mode()), and only then set the actual extended attribute
representing the new acl.

The problem is, none of these functions try to restore the original
permission bits if the second part fails. If this happens to a file that
had no acl attributes to begin with, the system will from now on assume
that the mask permission bits are actual group permission bits,
potentially granting access to the wrong users.

If your working directory is on a filesystem mounted with extended user
attributes (and acl of course), this script will trigger the issue by
filling the drive:


touch test.file
chmod go-rwx test.file
yes xxxxxxxxxx > test.file
i=1
while setfattr -n user.$i test.file; do
  ((++i))
done
setfacl -m m:r test.file


By the time the script returns, the group that owns test.file may have read
permissions that were never granted. This happens reliably on at least
ext2, ext4, jfs and reiserfs.

I will follow this mail with patch drafts for those filesystems. I believe
most filesystems that support acl will need a patch, but perhaps it's best
if I share what I have so far.

Thank you for your attention.

Ernesto A. Fernández (5):
  ext4: preserve i_mode if __ext4_set_acl() fails
  ext2: preserve i_mode if ext2_set_acl() fails
  ext2: fix line over 80 characters in ext2_set_acl()
  jfs: preserve i_mode if __jfs_set_acl() fails
  reiserfs: preserve i_mode if __reiserfs_set_acl() fails

 fs/ext2/acl.c           | 25 ++++++++++++++++---------
 fs/ext4/acl.c           | 15 +++++++++++----
 fs/jfs/acl.c            | 15 +++++++++++----
 fs/reiserfs/xattr.c     |  4 ++++
 fs/reiserfs/xattr_acl.c | 25 +++++++++----------------
 5 files changed, 51 insertions(+), 33 deletions(-)

-- 
2.1.4

