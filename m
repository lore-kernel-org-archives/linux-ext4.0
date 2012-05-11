From: Ludwig Nussel <ludwig.nussel@suse.de>
Subject: [PATCH resend split 0/3] implement uid and gid mount options for ext2, ext3 and ext4
Date: Fri, 11 May 2012 13:10:05 +0200
Message-ID: <1336734608-15157-1-git-send-email-ludwig.nussel@suse.de>
References: <1336660924-9598-1-git-send-email-ludwig.nussel@suse.d>
Cc: Ludwig Nussel <ludwig.nussel@suse.de>,
	linux-fsdevel@vger.kernel.org,
	Jan Kara <jack@suse.cz> (maintainer:EXT2 FILE SYSTEM),
	Rob Landley <rob@landley.net> (maintainer:DOCUMENTATION),
	Andrew Morton <akpm@linux-foundation.org> (maintainer:EXT3 FILE
	SYSTEM),
	Andreas Dilger <adilger.kernel@dilger.ca> (maintainer:EXT3 FILE
	SYSTEM),
	"Theodore Ts'o" <tytso@mit.edu> (maintainer:EXT4 FILE SYSTEM),
	linux-ext4@vger.kernel.org (open list:EXT2 FILE SYSTEM),
	linux-doc@vger.kernel.org (open list:DOCUMENTATION)
To: linux-kernel@vger.kernel.org
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1336660924-9598-1-git-send-email-ludwig.nussel@suse.d>
Sender: linux-doc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

When using 'real' file systems on removable storage devices such as
hard disks or usb sticks people quickly face the problem that their
Linux users have different uids on different machines. Therefore one
cannot modify or even read files created on a different machine
without running chown as root or storing everything with mode 777.
Simple file systems such as vfat don't have that problem as they
don't store file ownership information and one can pass the uid
files should belong to as mount option.

The following three patches (for 3.4.0-rc5) implement the uid (and
gid) mount option for ext2, ext3 and ext4 to make them actually
useful on removable media. If a file system is mounted with the uid
option all files appear to be owned by the specified uid. Only newly
created files actually end up with that uid as owner on disk though.
Ownership of existing files cannot be changed permanently if the uid
option was specified.
Optionally a second uid (diskuid) can be specified. This one is actually
written to the file system then. Useful if the filesytem is also used on a
system that does not support the uid option.

The feature can be used in two ways. Firstly via fstab by having the
admin add 'uid=useruid' in the fs_mntops column in addition to the
'user' or 'users' option. Secondly via e.g. udisks which would
automatically pass the uid of the calling user as option.

Ludwig Nussel (3):
  implement uid and gid mount options for ext2
  implement uid and gid mount options for ext3
  implement uid and gid mount options for ext4

 Documentation/filesystems/ext2.txt |    9 ++++++
 Documentation/filesystems/ext3.txt |    9 ++++++
 Documentation/filesystems/ext4.txt |    9 ++++++
 fs/ext2/ext2.h                     |    8 +++++
 fs/ext2/inode.c                    |   42 ++++++++++++++++++++------
 fs/ext2/super.c                    |   57 +++++++++++++++++++++++++++++++++++-
 fs/ext3/ext3.h                     |    8 +++++
 fs/ext3/inode.c                    |   50 ++++++++++++++++++++++---------
 fs/ext3/super.c                    |   57 +++++++++++++++++++++++++++++++++++-
 fs/ext4/ext4.h                     |    4 ++
 fs/ext4/inode.c                    |   50 ++++++++++++++++++++++---------
 fs/ext4/super.c                    |   49 ++++++++++++++++++++++++++++++-
 12 files changed, 311 insertions(+), 41 deletions(-)

-- 
1.7.7

