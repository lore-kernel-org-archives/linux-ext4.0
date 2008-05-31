From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] delete unused nodes in ext2fs_extent_delete
Date: Sat, 31 May 2008 00:19:06 -0400
Message-ID: <20080531041906.GF3380@mit.edu>
References: <48333F05.6080608@redhat.com> <20080529222401.GA19617@mit.edu> <483F5453.5060400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:39327 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752191AbYEaMuF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 31 May 2008 08:50:05 -0400
Content-Disposition: inline
In-Reply-To: <483F5453.5060400@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

One more addition.  If we delete the last entry in the root inode, we
need to set the depth of the tree to 0.

					- Ted

diff --git a/lib/ext2fs/extent.c b/lib/ext2fs/extent.c
index 19d7feb..65b2003 100644
--- a/lib/ext2fs/extent.c
+++ b/lib/ext2fs/extent.c
@@ -1248,7 +1248,8 @@ errcode_t ext2fs_extent_delete(ext2_extent_handle_t handle, int flags)
 	} else {
 		eh = (struct ext3_extent_header *) path->buf;
 		eh->eh_entries = ext2fs_cpu_to_le16(path->entries);
