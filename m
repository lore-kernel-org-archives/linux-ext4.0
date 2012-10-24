From: Tao Ma <tm@tao.ma>
Subject: [PATCH V7 00/23] ext4: Add inline data support
Date: Wed, 24 Oct 2012 10:50:02 +0800
Message-ID: <1351047002-4723-1-git-send-email-tm@tao.ma>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:45937 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934266Ab2JXCu2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 23 Oct 2012 22:50:28 -0400
Received: from [182.92.247.2] (port=36696 helo=tma-laptop1.taobao.ali.com)
	by box585.bluehost.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <tm@tao.ma>)
	id 1TQr35-0002AN-5A
	for linux-ext4@vger.kernel.org; Tue, 23 Oct 2012 20:50:27 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

From: Tao Ma <boyu.mt@taobao.com>

Hi list,

this is another try for the inline data support for ext4. There is
no major change from V6. I just rebased it to 3.7-rc1 and run
xfstests again it.

git diff --stat
 fs/ext4/Makefile  |    2 +-
 fs/ext4/dir.c     |   41 +-
 fs/ext4/ext4.h    |   89 +++-
 fs/ext4/extents.c |   22 +-
 fs/ext4/ialloc.c  |    4 +
 fs/ext4/inline.c  | 1878 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/inode.c   |  237 ++++++--
 fs/ext4/namei.c   |  492 ++++++++++-----
 fs/ext4/xattr.c   |   87 ++-
 fs/ext4/xattr.h   |  280 ++++++++
 10 files changed, 2855 insertions(+), 277 deletions(-)

Thanks
Tao
