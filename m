From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: [PATCH 01/13] mm: Remove VM_FAULT_HWPOISON_LARGE_MASK
Date: Thu, 17 Aug 2017 18:08:03 +0200
Message-ID: <20170817160815.30466-2-jack@suse.cz>
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

It is unused.

Reviewed-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Signed-off-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
---
 include/linux/mm.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 483e84cf9fc6..fa036093e76c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1143,8 +1143,6 @@ static inline void clear_page_pfmemalloc(struct page *page)
 #define VM_FAULT_FALLBACK 0x0800	/* huge page fault failed, fall back to small */
 #define VM_FAULT_DONE_COW   0x1000	/* ->fault has fully handled COW */
 
-#define VM_FAULT_HWPOISON_LARGE_MASK 0xf000 /* encodes hpage index for large hwpoison */
-
 #define VM_FAULT_ERROR	(VM_FAULT_OOM | VM_FAULT_SIGBUS | VM_FAULT_SIGSEGV | \
 			 VM_FAULT_HWPOISON | VM_FAULT_HWPOISON_LARGE | \
 			 VM_FAULT_FALLBACK)
-- 
2.12.3
