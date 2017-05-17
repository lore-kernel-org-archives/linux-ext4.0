From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2 v2] ext4: Fix SEEK_HOLE implementation
Date: Wed, 17 May 2017 14:07:37 +0200
Message-ID: <20170517120739.2529-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33736 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753718AbdEQMHp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 17 May 2017 08:07:45 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

here is second revision of the patch set to fix ext4 SEEK_HOLE implementation.
For more details see changelog of the first patch.

Changes since v1:
* Fix some more buggy cases
* Fix range check
* Simplify the code

								Honza
