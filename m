From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [RFC][PATCH V3 0/4] ext4: inode preferred block allocation
Date: Wed, 01 Dec 2010 15:06:37 +0900
Message-ID: <4CF5E5ED.40605@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:65041 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab0LAGM2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Dec 2010 01:12:28 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

This version changes the interface of e4defrag -r option to reallocate files
near the regular files. It is useful to coordinate boot related files.

For adding new feature to e4defrag, we implemented new two ioctls to allocate
preferred blocks by using inode preallocation (called inode PA). One is
EXT4_IOC_CONTROL_PA to create or discard inode PA, and the other is
EXT4_IOC_GET_PA to get inode PA information.

By using these ioctls, e4defrag can solve relevant file fragmentation. This
improves read performance in case of reading a lot of files that is in the
same directory. The result of the simple test suite with the following command
line shows 35% performance improvement.
# time find <kernel source directory> -type -f -exec cat {} >/dev/null \;

FS Use percentage  before defrag   after defrag
               7%          56.5s          34.7s
              57%          59.4s          36.7s
              96%          62.6s          39.9s

Here is v3 patch series with the following changes:
- Rebase 2.6.37-rc2 (kernel)
- Don't check the physical block number of inode PA in advisory mode (kernel)
- Don't merge inode PA if either physical block or file offset of PA is
  bigger than another PA's one (kernel)
- Relevant file defragmentation supports a regular file (command)
- Fix arithmetic error when general user executes e4defrag -r (command)

My previous post is here:
http://marc.info/?l=linux-ext4&m=128272678710600&w=4

This patch series consists of the following three kernel patches and
two e2fsprogs patch. They can be applied to the following trees.

ext4 patch queue:
commit: c4ae4a1752d3aa63cdb0531b03e604a9b273860f
e2fsprogs:
commit: b70506bffba208daa2dc176be9370bc198ecd221

[RFC][PATCH V3 1/4] ext4: add EXT4_IOC_CONTROL_PA to create/discard inode PA
[RFC][PATCH V3 2/4] ext4: sort and merge inode PA
[RFC][PATCH V3 3/4] ext4: add EXT4_IOC_GET_PA to get inode PA information
[RFC][PATCH V3 4/4] e4defrag: add solving relevant file fragmentation mode

All suggestions and comments are welcome.

Regards,
Kazuya Mio
