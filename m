From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 05/11] dax: make 'wait_table' global variable static
Date: Tue, 27 Sep 2016 14:47:56 -0600
Message-ID: <1475009282-9818-6-git-send-email-ross.zwisler@linux.intel.com>
References: <1475009282-9818-1-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>,
 linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1475009282-9818-1-git-send-email-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

The global 'wait_table' variable is only used within fs/dax.c, and
generates the following sparse warning:

fs/dax.c:39:19: warning: symbol 'wait_table' was not declared. Should it be static?

Make it static so it has scope local to fs/dax.c, and to make sparse happy.

Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 fs/dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 9b9be8a..ac28cdf 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -52,7 +52,7 @@
 #define DAX_WAIT_TABLE_BITS 12
 #define DAX_WAIT_TABLE_ENTRIES (1 << DAX_WAIT_TABLE_BITS)
 
-wait_queue_head_t wait_table[DAX_WAIT_TABLE_ENTRIES];
+static wait_queue_head_t wait_table[DAX_WAIT_TABLE_ENTRIES];
 
 static int __init init_dax_wait_table(void)
 {
-- 
2.7.4
