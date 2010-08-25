From: Kazuya Mio <k-mio@sx.jp.nec.com>
Subject: [RFC][PATCH V2 0/5] ext4: inode preferred block allocation
Date: Wed, 25 Aug 2010 17:50:37 +0900
Message-ID: <4C74D95D.2090907@sx.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org
To: ext4 <linux-ext4@vger.kernel.org>, Theodore Tso <tytso@mit.edu>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi,

For adding new feature to e4defrag, we implemented new two ioctls to allocate
preferred blocks by using inode PA. One is EXT4_IOC_CONTROL_PA to create or
discard inode PA, and the other is EXT4_IOC_GET_PA to get inode PA information.

By using these ioctls, e4defrag can solve relevant file fragmentation. This
improves read performance in case of reading a lot of files that is in the
same directory. The result of the simple test suite with the following command
line shows 35% performance improvement.
# time find <kernel source directory> -type -f -exec cat {} >/dev/null \;

FS Use percentage  before defrag   after defrag
               7%          57.5s          37.1s
              57%          59.9s          38.6s
              96%          66.7s          44.2s

Here is v2 patch series with the following changes:
- Add e4defrag patch to support solving relevant file fragmentation mode that
  reallocates files near their parent directory
- Fix overflow while checking physical block upper limit
- Rebase on the current ext4 patch queue

My previous post is here:
http://marc.info/?l=linux-ext4&m=127123344916909&w=4

This patch series consists of the following three kernel patches and
two e2fsprogs patch. They can be applied to the following trees.

ext4 patch queue:
commit: 9db9d1a9d54b6968e22e8d164b8e7adbb6347bdf
e2fsprogs:
commit: ccc7cf032852dd5c84b227bafb481b1d158e2b5e

[RFC][PATCH V2 1/5] ext4: add EXT4_IOC_CONTROL_PA to create/discard inode PA
[RFC][PATCH V2 2/5] ext4: sort and merge inode PA
[RFC][PATCH V2 3/5] ext4: add EXT4_IOC_GET_PA to get inode PA information
[RFC][PATCH V2 4/5] e4defrag: unified bugfix/improvement patches
[RFC][PATCH V2 5/5] e4defrag: add solving relevant file fragmentation mode

All suggestions and comments are welcome.

Regards,
Kazuya Mio
