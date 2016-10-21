From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] fs: Provide function to unmap metadata for a range of blocks
Date: Fri, 21 Oct 2016 13:55:37 +0200
Message-ID: <1477050941-29682-1-git-send-email-jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Jan Kara <jack@suse.cz>
To: Jens Axboe <axboe@kernel.dk>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52797 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754148AbcJULzu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 21 Oct 2016 07:55:50 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I've noticed that in several places we need to unmap metadata in buffer cache
for a range of blocks and we do it by iterating over all blocks in given
range. Let's provide a helper function for that and implement it in a way
more efficient for larger ranges or blocks. The patches passed xfstests
for ext2 and ext4.

Jens, can you merge these patches if they look fine to you?

								Honza
