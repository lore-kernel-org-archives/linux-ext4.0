From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/7 v4] DAX cleanups and fixes
Date: Wed, 11 May 2016 11:58:46 +0200
Message-ID: <1462960733-29634-1-git-send-email-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>
To: linux-nvdimm@lists.01.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751741AbcEKJ7W (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 11 May 2016 05:59:22 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

This is another part of the series that implements new DAX page fault locking.
This part contains easy DAX cleanups and fixes that were already reviewed and
are rather obvious so they could be merged right away. They mostly remove
dead unused code. The patches didn't change since the last posting of the DAX
page fault locking series except for some added Reviewed-by tags.

Since DAX error handling patches depend on these I assume they will get merged
through NVDIMM tree.  These patches depend on ext4 fixes from the series "ext4:
DAX fixes". The dependency is mostly functional (these patches remove zeroing
from DAX code and ext4 was depending on this zeroing until the above series
fixed that) so NVDIMM tree should be merged after ext4 tree to avoid breaking
ext4 DAX support.

								Honza
