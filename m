From: Jan Kara <jack@suse.cz>
Subject: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
Date: Thu,  5 Jan 2012 15:40:04 +0100
Message-ID: <1325774407-28531-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Edward Shishkin <edward@redhat.com>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org


  Hello,

  for mostly historical reasons we still clear buffer_uptodate flag on write
IO errors. This is not only semantically wrong (buffer still has correct data
in it) but it also triggers warnings in mark_buffer_dirty when buffer is
written again which scares lots of users (as they tend to unplug USB sticks
too early). This patch series is an attempt to start solving the problem
by allowing filesystem to tell whether it wishes buffer_uptodate flag cleared
on write IO error. Ext2 is converted to use this as an example. Eventually
when all filesystems are converted, we can remove the condition.

Do people think this is a desirable way to go?

								Honza
