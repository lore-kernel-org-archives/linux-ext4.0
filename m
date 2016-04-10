From: Greg Thelen <gthelen@google.com>
Subject: Re: [GIT PULL] ext4 bug fixes for 4.6
Date: Sat, 09 Apr 2016 19:23:57 -0700
Message-ID: <xr93bn5iyzeq.fsf@gthelen.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


Theodore Ts'o wrote:

> The following changes since commit 243d50678583100855862bc084b8b307eea67f68:
>
>   Merge branch 'overlayfs-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs (2016-03-22 13:11:15 -0700)
>
n> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git tags/ext4_for_linus_stable
>
> for you to fetch changes up to c325a67c72903e1cc30e990a15ce745bda0dbfde:
>
>   ext4: ignore quota mount options if the quota feature is enabled (2016-04-03 17:03:37 -0400)
>
> ----------------------------------------------------------------
> These changes contains a fix for overlayfs interacting with some
> (badly behaved) dentry code in various file systems.  These have been
> reviewed by Al and the respective file system mtinainers and are going
> through the ext4 tree for convenience.
>
> This also has a few ext4 encryption bug fixes that were discovered in
> Android testing (yes, we will need to get these sync'ed up with the
> fs/crypto code; I'll take care of that).  It also has some bug fixes
> and a change to ignore the legacy quota options to allow for xfstests
> regression testing of ext4's internal quota feature and to be more
> consistent with how xfs handles this case.
>
> ----------------------------------------------------------------
> Dan Carpenter (1):
>       ext4 crypto: fix some error handling
>
> Filipe Manana (1):
>       btrfs: fix crash/invalid memory access on fsync when using overlayfs
>
> Jan Kara (1):
>       ext4: retry block allocation for failed DIO and DAX writes
>
> Miklos Szeredi (4):
>       fs: add file_dentry()
>       nfs: use file_dentry()
>       ext4: use dget_parent() in ext4_file_open()
>       ext4: use file_dentry()
>
> Theodore Ts'o (7):
>       ext4: check if in-inode xattr is corrupted in ext4_expand_extra_isize_ea()
>       ext4 crypto: don't let data integrity writebacks fail with ENOMEM
>       ext4 crypto: use dget_parent() in ext4_d_revalidate()
>       ext4: allow readdir()'s of large empty directories to be interrupted

Ted,

I've been testing 5b5b7fd185e9 (linus/master) and seeing that
interrupted readdir() now returns duplicate dirents.

Reverting commit 1028b55bafb7 ("ext4: allow readdir()'s of large empty
directories to be interrupted") avoids duplicates.

On 5b5b7fd185e9 a SIGPROF to the test program below occasionally causes
"already seen name" error.  On older kernels, it runs indefinitely
without error.

/*
  mkdir /tmp/foo
  cd /tmp/foo
  for i in $(seq 0 599); do touch $i; done
  /tmp/scanner &
  kill -PROF %1
 */

#include <dirent.h>
#include <err.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>

static void handler(int unused)
{
}

int main() {
	enum { count = 600 };
	char seen[count];
	struct dirent *ent;
	DIR *dir;
	struct sigaction sa = {0};

	sa.sa_handler = handler;
	if (sigemptyset(&sa.sa_mask))
		err(1, "sigemptyset");
	sa.sa_flags = SA_RESTART;
	if (sigaction(SIGPROF, &sa, NULL))
		err(1, "sigaction");

	for (;;) {
		memset(seen, 0, sizeof(seen));
		dir = opendir(".");
		if (dir == NULL)
			err(1, "opendir(.)");
		while ((ent = readdir(dir)) != NULL) {
			int idx;

			if ((strcmp(ent->d_name, ".") == 0) ||
			    (strcmp(ent->d_name, "..") == 0)) {
				continue;
			}
			idx = atoi(ent->d_name);
			if (idx >= count) {
				errx(1, "bogus name %s index %d", ent->d_name, idx);
			}
			if (seen[idx]) {
				errx(1, "already seen name %s index %d", ent->d_name, idx);
			}
			seen[idx] = 1;
		}
		if (closedir(dir))
			err(1, "closedir(.)");
	}
}

>       ext4: add lockdep annotations for i_data_sem
>       ext4: avoid calling dquot_get_next_id() if quota is not enabled
>       ext4: ignore quota mount options if the quota feature is enabled
>
>  fs/btrfs/file.c        |  2 +-
>  fs/dcache.c            |  5 ++++-
>  fs/ext4/crypto.c       | 49 +++++++++++++++++++++++++++++--------------------
>  fs/ext4/dir.c          |  5 +++++
>  fs/ext4/ext4.h         | 29 +++++++++++++++++++++++++++--
>  fs/ext4/file.c         | 12 ++++++++----
>  fs/ext4/inode.c        | 58 ++++++++++++++++++++++++++++------------------------------
>  fs/ext4/move_extent.c  | 11 +++++++++--
>  fs/ext4/namei.c        |  5 +++++
>  fs/ext4/page-io.c      | 14 +++++++++++++-
>  fs/ext4/readpage.c     |  2 +-
>  fs/ext4/super.c        | 61 +++++++++++++++++++++++++++++++++++++++++++++++--------------
>  fs/ext4/xattr.c        | 32 ++++++++++++++++++++++++++++----
>  fs/nfs/dir.c           |  6 +++---
>  fs/nfs/inode.c         |  2 +-
>  fs/nfs/nfs4file.c      |  4 ++--
>  fs/overlayfs/super.c   | 33 +++++++++++++++++++++++++++++++++
>  include/linux/dcache.h | 10 ++++++++++
>  include/linux/fs.h     | 10 ++++++++++
>  19 files changed, 264 insertions(+), 86 deletions(-)
