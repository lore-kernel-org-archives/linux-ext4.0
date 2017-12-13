From: Jan Kara <jack@suse.cz>
Subject: [PATCH 0/2] ext4: Fix ENOSPC handling for DAX faults
Date: Wed, 13 Dec 2017 10:13:50 +0100
Message-ID: <20171213091352.23448-1-jack@suse.cz>
Cc: Ted Tso <tytso@mit.edu>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        <linux-fsdevel@vger.kernel.org>, linux-nvdimm@lists.01.org,
        Jan Kara <jack@suse.cz>
To: <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59047 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751479AbdLMJOF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 13 Dec 2017 04:14:05 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

these two patches fix handling of ENOSPC during DAX faults. The problem is
that currently running transaction may be holding lots of already freed
blocks which can be reallocated only once the transaction commits. Standard
retry logic in ext4_iomap_end() does not work for DAX page fault handler
since we hold current transaction open in ext4_dax_huge_fault() and thus
retry logic cannot force the running transaction and as a result application
gets SIGBUS due to premature ENOSPC error.

These two patches fix the problem. I'm not too happy about patch 1/2 passing
additional info (error code) from the fault handler but I don't see an
easy better option since we want to also pass back special return values
like VM_FAULT_FALLBACK. Comments are welcome.

								Honza
