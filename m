From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2 v3] ext4: Fix SEEK_HOLE implementation
Date: Thu, 18 May 2017 12:49:40 +0200
Message-ID: <20170518104942.14588-1-jack@suse.cz>
Cc: <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>
To: Ted Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47724 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932342AbdERKuE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 18 May 2017 06:50:04 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

here is second revision of the patch set to fix ext4 SEEK_HOLE implementation.
For more details see changelog of the first patch.

Changes since v2:
* Fixed rounding error spotted by Eryu

Changes since v1:
* Fix some more buggy cases
* Fix range check
* Simplify the code

								Honza
