From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC PATCH 0/2] add some stats in es shrinker and do some cleanups in tracepoint
Date: Tue, 14 Jan 2014 16:06:39 +0800
Message-ID: <1389686801-11367-1-git-send-email-wenqing.lz@taobao.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jan Kara <jack@suse.cz>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:40368 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaANICu (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 14 Jan 2014 03:02:50 -0500
Received: by mail-pa0-f44.google.com with SMTP id kq14so2209529pab.31
        for <linux-ext4@vger.kernel.org>; Tue, 14 Jan 2014 00:02:49 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi all,

This patch set contains two patches.  The first one is a trival patch,
which does some cleanups for the trace point of extent status tree
shrinker.  The second one is to add some statistics for extent status
tree shrinker in order that we want to collect some more details when
we encounter a stall.  As discussion with Ted and other folks, we need
to add some counters to reflect the behaviour of the shrinker, and later
we can use these counters to measure the performance for the shrinker
improvements.  Meanwhile these information can help us to reproduce the
problem when the user reports that their machine is stall caused by the
shrinker.

Any comment or suggestion are always welcome.

Thanks,
						- Zheng

Zheng Liu (2):
  ext4: improve extents status tree trace point
  ext4: track extent status tree shrinker delay statictics

 fs/ext4/ext4.h              |    4 +-
 fs/ext4/extents_status.c    |  177 +++++++++++++++++++++++++++++++++++++++----
 fs/ext4/extents_status.h    |   10 ++-
 fs/ext4/super.c             |   17 ++---
 include/trace/events/ext4.h |   59 +++++++++++++--
 5 files changed, 233 insertions(+), 34 deletions(-)

-- 
1.7.9.7

