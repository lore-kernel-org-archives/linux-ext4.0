From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/10 v2] Ranged pagevec lookup
Date: Wed, 26 Jul 2017 13:46:54 +0200
Message-ID: <20170726114704.7626-1-jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        linux-fsdevel@vger.kernel.org
To: <linux-mm@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54157 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751534AbdGZLr1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 26 Jul 2017 07:47:27 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

This patch series was split out of the larger series to clean up pagevec APIs
and provide ranged lookups. In this series I make pagevec_lookup() update the
index (to be consistent with pagevec_lookup_tag() and also as a preparation
for ranged lookups), provide ranged variant of pagevec_lookup() and use it
in places where it makes sense. This not only removes some common code but
is also a measurable performance win for some use cases (see patch 4/10) where
radix tree is sparse and searching & grabing of a page after the end of the
range has measurable overhead.

Andrew, can you please consider merging this series?

Full series including dependencies can be also obtained from my git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs.git find_get_pages_range

Opinions and review welcome!

								Honza
