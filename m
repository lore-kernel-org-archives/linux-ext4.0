From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4 v2] ext4: Fix races between writeback and truncate
Date: Mon,  5 Aug 2013 15:52:20 +0200
Message-ID: <1375710744-29329-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Dave Jones <davej@redhat.com>,
	Zheng Liu <gnehzuil.liu@gmail.com>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55415 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752831Ab3HENw2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Aug 2013 09:52:28 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

  this patch set fixes two races between truncate and writeback code.
The first one was introduced by my rewrite of ext4 writeback path and
Dave and Zheng have spotted them in their testing. It could result in
some leaked fs blocks and delalloc accounting mismatch. The first two
patches fix that bug.

The second race has been there for ages and could result in i_size being
wrong on disk. The last two patches fix that race.

								Honza
