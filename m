From: Theodore Ts'o <tytso@mit.edu>
Subject: [PATCH 0/2] Re: Discrepancy in 'df' output between kernel 3.0 and 3.2 for ext4?
Date: Mon, 18 Jun 2012 17:45:07 -0400
Message-ID: <1340055909-7683-1-git-send-email-tytso@mit.edu>
References: <4FD8D731.9070008@cleversafe.com>
Cc: zmark@cleversafe.com, Theodore Ts'o <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51169 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753659Ab2FRVpL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 Jun 2012 17:45:11 -0400
In-Reply-To: <4FD8D731.9070008@cleversafe.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Zachary,

Hopefully this should fix the problem which you noted.


Theodore Ts'o (2):
  ext4: pass a char * to ext4_count_free() instead of a buffer_head ptr
  ext4: fix overhead calculation used by ext4_statfs()

 fs/ext4/balloc.c |   3 +-
 fs/ext4/bitmap.c |  12 +---
 fs/ext4/ext4.h   |   6 +-
 fs/ext4/ialloc.c |   3 +-
 fs/ext4/resize.c |   7 ++-
 fs/ext4/super.c  | 174 +++++++++++++++++++++++++++++++++++++++----------------
 6 files changed, 140 insertions(+), 65 deletions(-)

-- 
1.7.11

