From: Eric Whitney <enwlinux@gmail.com>
Subject: [PATCH 0/4] ext4: bigalloc partial cluster handling fixes
Date: Fri, 21 Nov 2014 09:52:47 -0500
Message-ID: <20141121145247.GA30246@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tytso@mit.edu
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f45.google.com ([209.85.192.45]:52889 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755757AbaKUOwy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Nov 2014 09:52:54 -0500
Received: by mail-qg0-f45.google.com with SMTP id f51so3758276qge.32
        for <linux-ext4@vger.kernel.org>; Fri, 21 Nov 2014 06:52:54 -0800 (PST)
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Some xfstests that perform hole punching operations fail as a result of
partial cluster handling bugs when run on bigalloc file systems.  These
failures are manifested in the form of bad i_blocks values and block
bitmap differences reported by e2fsck when it is run on the test
filesystem at the conclusion of these xfstests.  e2fsck typically
reports that the file system is inconsistent, and messages may appear
in the kernel log indicating that freed blocks are already on the
to-be-freed list, a block bitmap is corrupt, etc.  Depending upon the
bug encountered, both overfreeing and underfreeing of blocks can occur.

Examples of these xfstests include generic/300 and shared/298.  Once
the first patch in this series is applied, new failures (generic/013,
for example) may appear and then disappear with successive patch
applications until all have been applied.

Eric Whitney (4):
  ext4: fix partial cluster initialization
  ext4: fix end of leaf partial cluster handling
  ext4: miscellaneous partial cluster cleanups
  ext4: fix end of region partial cluster handling

 fs/ext4/extents.c | 169 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 92 insertions(+), 77 deletions(-)

-- 
1.9.1

