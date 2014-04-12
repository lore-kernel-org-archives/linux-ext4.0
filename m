From: Theodore Ts'o <tytso@mit.edu>
Subject: [RFC PATCH 0/5] Clean up ext4_file_write()
Date: Sat, 12 Apr 2014 13:02:36 -0400
Message-ID: <1397322161-32148-1-git-send-email-tytso@mit.edu>
Cc: viro@ZenIV.linux.org.uk, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53224 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935AbaDLRCv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Apr 2014 13:02:51 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

This patch series makes ext4_file_write() a bit easier to understand by
eliminating ext4_file_dio_write() and merging common code together.

In addition, fix an O_APPEND locking issue which Al Viro pointed out.

Theodore Ts'o (5):
  ext4: inline generic_file_aio_write() into ext4_file_write()
  ext4: move ext4_file_dio_write() into ext4_file_write()
  ext4: drop aio_mutex after grabbing i_mutex in ext4_file_write()
  ext4: factor out common code in ext4_file_write()
  ext4: add locking for O_APPEND writes

 fs/ext4/file.c | 153 +++++++++++++++++++++++++++++----------------------------
 1 file changed, 78 insertions(+), 75 deletions(-)

-- 
1.9.0

