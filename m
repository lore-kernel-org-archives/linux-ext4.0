From: "Duane Griffin" <duaneg@dghda.com>
Subject: jbd/2: eliminate code duplication and gracefully handle cache initialisation failure
Date: Sat,  8 Mar 2008 18:37:33 +0000
Message-ID: <1205001459-5291-1-git-send-email-duaneg@dghda.com>
Cc: linux-kernel@vger.kernel.org,
	Christoph Hellwig <hch@infradead.org>,
	Theodore Tso <tytso@mit.edu>, sct@redhat.com,
	akpm@linux-foundation.org, adilger@clusterfs.com,
	Duane Griffin <duaneg@dghda.com>
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kumera.dghda.com ([80.68.90.171]:2217 "EHLO kumera.dghda.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246AbYCHShp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Mar 2008 13:37:45 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

 fs/jbd/journal.c  |  149 +++++++++++++++++++++++-------------------------
 fs/jbd/revoke.c   |  164 +++++++++++++++++++++++------------------------------
 fs/jbd2/journal.c |  154 ++++++++++++++++++++++++-------------------------
 fs/jbd2/revoke.c  |  164 +++++++++++++++++++++++------------------------------
 4 files changed, 291 insertions(+), 340 deletions(-)

This is version 2 of the jdb/2 patches to eliminate code duplication and
gracefully handle cace initialisation failure.

Changes since V1:
 * Check whether caches are initialised in journal_init_common. If not then
   attempt to initialise them once before failing.
 * Addressed all Andreas Dilger's comments.
 * Modified the initialisation/destruction methods to match Christoph Hellwig's
   suggestions.
 * Rolled the if/assertion and debugfs changes into the main patch.

Andrew, please drop the earlier versions of these patches and replace them with
these ones, thanks.

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
