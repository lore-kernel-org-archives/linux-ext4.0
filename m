From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/11 v2] ext4: Convert ext4 DAX IO to iomap framework
Date: Tue,  8 Nov 2016 12:08:06 +0100
Message-ID: <1478603297-11793-1-git-send-email-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34457 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752961AbcKHLKE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 8 Nov 2016 06:10:04 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

this is a second revision of my patches to convert ext4 DAX IO paths to the new
iomap framework and removes the old bh-based DAX functions. As a result ext4
gains PMD page fault support, also some other minor bugs get fixed. The patch
set is based on Ross' DAX PMD page fault support series [1]. It passes xfstests
both in DAX and non-DAX mode.

I have pushed out updated version of these patches including the follow-up
DAX patches to:

git://get.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git dax

for easy testing. Once Dave pushes out a stable branch with Ross' patches, we
pull those into ext4 tree and then pull these patches on top of that (provided
nobody will have other objections to the current series).

Changes since v1:
* Changed ext4_iomap_begin() and ext4_iomap_end() to not keep transaction
  handle running between these two functions as that causes lock ordering
  issues.

								Honza

[1] http://www.spinics.net/lists/linux-mm/msg115875.html
