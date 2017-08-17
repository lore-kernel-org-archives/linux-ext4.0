From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 07/13] dax: Inline dax_pmd_insert_mapping() into the callsite
Date: Thu, 17 Aug 2017 18:08:09 +0200
Message-ID: <20170817160815.30466-8-jack@suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Boaz Harrosh <boazh-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>,
 Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170817160815.30466-1-jack-AlSwsSmVLrQ@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-ext4.vger.kernel.org

dax_pmd_insert_mapping() has only one callsite and we will need to
further fine tune what it does for synchronous faults. Just inline it
into the callsite so that we don't have to pass awkward bools around.

Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 fs/dax.c                      | 43 ++++++++++++++-----------------------------
 include/trace/events/fs_dax.h |  1 -
 2 files changed, 14 insertions(+), 30 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 766cb840c276..54d2a9161f71 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1230,34 +1230,6 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
  */
 #define PG_PMD_COLOUR	((PMD_SIZE >> PAGE_SHIFT) - 1)
 
-static int dax_pmd_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
-		loff_t pos, void *entry)
-{
-	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
-	const sector_t sector = dax_iomap_sector(iomap, pos);
-	struct inode *inode = mapping->host;
-	void *ret = NULL;
-	pfn_t pfn;
-	int rc;
-
-	rc = dax_iomap_pfn(iomap, pos, PMD_SIZE, &pfn);
-	if (rc < 0)
-		goto fallback;
-
-	ret = dax_insert_mapping_entry(mapping, vmf, entry, sector,
-			RADIX_DAX_PMD);
-	if (IS_ERR(ret))
-		goto fallback;
-
-	trace_dax_pmd_insert_mapping(inode, vmf, PMD_SIZE, pfn, ret);
-	return vmf_insert_pfn_pmd(vmf->vma, vmf->address, vmf->pmd,
-			pfn, vmf->flags & FAULT_FLAG_WRITE);
-
-fallback:
-	trace_dax_pmd_insert_mapping_fallback(inode, vmf, length, pfn, ret);
-	return VM_FAULT_FALLBACK;
-}
-
 static int dax_pmd_load_hole(struct vm_fault *vmf, struct iomap *iomap,
 		void *entry)
 {
@@ -1312,6 +1284,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
 	void *entry;
 	loff_t pos;
 	int error;
+	pfn_t pfn;
 
 	/*
 	 * Check whether offset isn't beyond end of file now. Caller is
@@ -1379,7 +1352,19 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
 
 	switch (iomap.type) {
 	case IOMAP_MAPPED:
-		result = dax_pmd_insert_mapping(vmf, &iomap, pos, entry);
+		error = dax_iomap_pfn(&iomap, pos, PMD_SIZE, &pfn);
+		if (error < 0)
+			goto finish_iomap;
+
+		entry = dax_insert_mapping_entry(mapping, vmf, entry,
+						dax_iomap_sector(&iomap, pos),
+						RADIX_DAX_PMD);
+		if (IS_ERR(entry))
+			goto finish_iomap;
+
+		trace_dax_pmd_insert_mapping(inode, vmf, PMD_SIZE, pfn, entry);
+		result = vmf_insert_pfn_pmd(vma, vmf->address, vmf->pmd, pfn,
+					    write);
 		break;
 	case IOMAP_UNWRITTEN:
 	case IOMAP_HOLE:
diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
index fbc4a06f7310..88a9d19b8ff8 100644
--- a/include/trace/events/fs_dax.h
+++ b/include/trace/events/fs_dax.h
@@ -148,7 +148,6 @@ DEFINE_EVENT(dax_pmd_insert_mapping_class, name, \
 	TP_ARGS(inode, vmf, length, pfn, radix_entry))
 
 DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping);
-DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping_fallback);
 
 DECLARE_EVENT_CLASS(dax_pte_fault_class,
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf, int result),
-- 
2.12.3
