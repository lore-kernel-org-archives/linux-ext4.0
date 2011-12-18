From: Tao Ma <tm@tao.ma>
Subject: [PATCH V3 00/21] ext4: Add inline data support.
Date: Sun, 18 Dec 2011 22:20:33 +0800
Message-ID: <4EEDF6B1.7050206@tao.ma>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: LKML <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	tm@tao.ma
To: Andreas Dilger <adilger@dilger.ca>, Theodore Ts'o <tytso@mit.edu>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:36804 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751841Ab1LROVK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 18 Dec 2011 09:21:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Ted, Andreas and list,
        This is the v3 attempt to add inline data support to ext4 inode.
For more information about the background, please refer to the thread
http://marc.info/?l=linux-ext4&m=131715205428067&w=2

Changelog from v2 to v3:
1. Add support for evict data from inode if we can store xattr in it.
2. Add support for fiemap
3. Some nasty bug fixes

The v2 can be found here:
http://marc.info/?l=linux-ext4&m=132189338604177&w=2

The v1 can be found here:
http://marc.info/?l=linux-ext4&m=131961438221255&w=2

any suggestions are welcomed.

git diff --stat master..
 fs/ext4/Makefile  |    2 +-
 fs/ext4/dir.c     |   39 +-
 fs/ext4/ext4.h    |   77 +++-
 fs/ext4/extents.c |   18 +-
 fs/ext4/ialloc.c  |    4 +
 fs/ext4/inline.c  | 1642
+++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c   |  236 ++++++--
 fs/ext4/namei.c   |  364 +++++++++----
 fs/ext4/xattr.c   |   64 +--
 fs/ext4/xattr.h   |  263 +++++++++
 10 files changed, 2481 insertions(+), 228 deletions(-)

Thanks
Tao
