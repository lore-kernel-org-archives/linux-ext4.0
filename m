From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/5] ext4: Fix softlockups in ext4_seek_data()
Date: Thu,  3 Mar 2016 11:23:46 +0100
Message-ID: <1457000631-10215-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51038 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755544AbcCCKXj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 3 Mar 2016 05:23:39 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

I've seen several reports of softlockups somewhere under ext4_seek_data()
usually during fuzzing. The culprit is that ext4_seek_data() iterates holes
block by block and thus suitably crafted file can make ext4_seek_data() do
a *lot* of lookups using ext4_map_blocks() which is slow. This is really
unnecessary since in principle we have all the information for efficient
skipping of holes, just a layer below. Even for indirect-block based files
we can easily reduce the asymptotic complexity of hole iteration from linear
to logarithmic albeit with a relatively large constant.

Patches 1 and 4 in this series are independent cleanups I've spotted while
changing the code, they can be merged separately. Patches 2 and 3 are
preparatory changes which make ext4_map_blocks() return hole size in
map->m_len field. We still return 0 from ext4_map_blocks() calls finding hole
to maintain backward compatibility of this function and it still makes sense
as such - it still returns the number of allocated blocks starting at given
logical offset. Patch 5 then uses the newly available information in
ext4_seek_data() and it also rewrites ext4_seek_hole() so that both functions
are symmetric.

								Honza
