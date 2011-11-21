From: Tao Ma <tm@tao.ma>
Subject: [PATCH V2 00/19] ext4: Add inline data support.
Date: Tue, 22 Nov 2011 00:34:59 +0800
Message-ID: <4ECA7DB3.9040605@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Andreas Dilger <adilger@d
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:44532 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753627Ab1KUQfO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Nov 2011 11:35:14 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted, Andreas and list,
	This is the v2 attempt to add inline data support to ext4 inode.
Formore information about the background, please refer to the thread
http://marc.info/?l=linux-ext4&m=131715205428067&w=2

In V1 I uses all the space between i_extra_isize and inode_size if
inode_size = 256. For inode_size > 256, half of that space is used so as
to leave some space for other xattrs. Andreas suggested that it would
make xattr set/get less efficient since it takes too much space for a
small inode and xttr would be evicted to the external block. So this V2
now uses the extent space for an inode(60 bytes) at first and then it
will try to extend inline data by using the xattr space. So if there are
no other xattr, now we can have up to 132 bytes to store the inline data
for a inode_size=256. And also as Amir suggested, I have moved all the
corresponding codes to fs/ext4/inline.c so that we don't pollute inode.c
too much.

Some simple tests shows that with a linux-3.0 vanilla source, the new
dir can save more than 1% disk space. For my "/usr", it can save more
than 3% spaces. I guess for volume with future bigalloc support, it
should save more space for us for small dir.

There are still something to do in my list:
1. yes, e2fsprogs is very important and we are working on it.
2. evicting inline data in xattr set if the xattr can be inserted into
inode as suggested by Andreas.

any suggestions are welcomed.

git diff --stat master..
 fs/ext4/Makefile  |    2 +-
 fs/ext4/dir.c     |   36 +-
 fs/ext4/ext4.h    |   72 +++-
 fs/ext4/extents.c |    9 +-
 fs/ext4/ialloc.c  |    4 +
 fs/ext4/inline.c  | 1426
+++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c   |  209 ++++++--
 fs/ext4/namei.c   |  348 +++++++++----
 fs/ext4/xattr.c   |   39 +--
 fs/ext4/xattr.h   |  256 ++++++++++
 10 files changed, 2185 insertions(+), 216 deletions(-)

Thanks
Tao
