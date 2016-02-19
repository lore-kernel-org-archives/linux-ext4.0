From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/6] ext4: Clean up io_end handling for AIO DIO
Date: Fri, 19 Feb 2016 16:59:36 +0100
Message-ID: <1455897582-13292-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56630 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947566AbcBSP71 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 19 Feb 2016 10:59:27 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

Recently I had a look at how io_ends are handled for AIO DIO. When doing AIO
DIO we allocate io_end and attach it to inode. ext4_ext_map_blocks() then
fetches io_end from inode and operates on it. This scheme is somewhat fragile
because it relies on the fact that we hold i_mutex whenever we need io_end
which is non-obvious dependency (if it was not for io_end handling, i_data_sem
would be enough). dioread_nolock mode broke this assumption and was corrupting
io_end pointers until recently which somewhat demostrates my point.

This patch set converts ext4 to allocate io_end only once we spot unwritten
extent during direct IO write and uses bh->b_private and dio->private
to store it in the same fashion as XFS. That way passing of io_end pointer
happens via IO-local context and is thus independent of any locks.

The core of the change is in patch 5/6, the rest are related cleanups and
preparations for the change.

Patches pass xfstests in normal and dioread_nolock mode. Patch 5/6 conflicts
with changes of DIO completion on error however resolving these conflicts
should be straightforward.

								Honza
