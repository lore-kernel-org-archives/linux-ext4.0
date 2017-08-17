From: Jan Kara <jack@suse.cz>
Subject: [PATCH 08/13] dax: Fix comment describing dax_iomap_fault()
Date: Thu, 17 Aug 2017 18:08:10 +0200
Message-ID: <20170817160815.30466-9-jack@suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
Cc: linux-nvdimm@lists.01.org, Andy Lutomirski <luto@kernel.org>,
        <linux-ext4@vger.kernel.org>, <linux-xfs@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Ross Zwisler <ross.zwisler@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>
To: <linux-fsdevel@vger.kernel.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20170817160815.30466-1-jack@suse.cz>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Add missing argument description.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 54d2a9161f71..85ea49bbbdbf 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1414,7 +1414,8 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
 /**
  * dax_iomap_fault - handle a page fault on a DAX file
  * @vmf: The description of the fault
- * @ops: iomap ops passed from the file system
+ * @pe_size: Size of the page to fault in
+ * @ops: Iomap ops passed from the file system
  *
  * When a page fault occurs, filesystems may call this helper in
  * their fault handler for DAX files. dax_iomap_fault() assumes the caller
-- 
2.12.3
