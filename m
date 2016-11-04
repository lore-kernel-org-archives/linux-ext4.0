From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/6 v2] fs: Provide function to unmap metadata for a range of blocks
Date: Fri,  4 Nov 2016 18:08:10 +0100
Message-ID: <1478279296-6575-1-git-send-email-jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, Evgeniy Dushistov <dushistov@mail.ru>,
        linux-ntfs-dev@lists.sourceforge.net, Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35615 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933335AbcKDRI0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 4 Nov 2016 13:08:26 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I've noticed that in several places we need to unmap metadata in buffer cache
for a range of blocks and we do it by iterating over all blocks in given range.
Let's provide a helper function for that and implement it in a way more
efficient for larger ranges of blocks. Also cleanup other uses of
unmap_unerlying_metadata().  The patches passed xfstests for ext2 and ext4.

Jens, can you merge these patches if they look fine to you?

Changes since v1:
* Improved comment describing what the function does
* Renamed function
* Added wrapper for single block users and use it

								Honza
