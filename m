From: Jan Kara <jack@suse.cz>
Subject: [RFC v3] [PATCH 0/18] DAX page fault locking
Date: Mon, 18 Apr 2016 23:35:23 +0200
Message-ID: <1461015341-20153-1-git-send-email-jack@suse.cz>
Cc: linux-ext4@vger.kernel.org,
	linux-mm@kvack.org,
	Ross Zwisler <ross.zwisler@linux.intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-nvdimm@lists.01.org,
	Matthew Wilcox <willy@linux.intel.com>,
	Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

Hello,

this is my third attempt at DAX page fault locking rewrite. The patch set has
passed xfstests both with and without DAX mount option on ext4 and xfs for
me and also additional page fault beating using the new page fault stress
tests I have added to xfstests. So I'd be grateful if you guys could have a
closer look at the patches so that they can be merged. Thanks.

Changes since v2:
- lot of additional ext4 fixes and cleanups
- make PMD page faults depend on CONFIG_BROKEN instead of #if 0
- fixed page reference leak when replacing hole page with a pfn
- added some reviewed-by tags
- rebased on top of current Linus' tree

Changes since v1:
- handle wakeups of exclusive waiters properly
- fix cow fault races
- other minor stuff

General description

The basic idea is that we use a bit in an exceptional radix tree entry as
a lock bit and use it similarly to how page lock is used for normal faults.
That way we fix races between hole instantiation and read faults of the
same index. For now I have disabled PMD faults since there the issues with
page fault locking are even worse. Now that Matthew's multi-order radix tree
has landed, I can have a look into using that for proper locking of PMD faults
but first I want normal pages sorted out.

In the end I have decided to implement the bit locking directly in the DAX
code. Originally I was thinking we could provide something generic directly
in the radix tree code but the functions DAX needs are rather specific.
Maybe someone else will have a good idea how to distill some generally useful
functions out of what I've implemented for DAX but for now I didn't bother
with that.

								Honza

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
