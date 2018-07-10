From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [fstests PATCH v2 1/2] src/: add license and copyright info to files
Date: Tue, 10 Jul 2018 16:09:41 -0600
Message-ID: <20180710220942.21074-2-ross.zwisler@linux.intel.com>
References: <20180710220942.21074-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eryu Guan <eguan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20180710220942.21074-1-ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
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

Add copyright and license info to files that I've authored in src/.

Signed-off-by: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 src/t_ext4_dax_inline_corruption.c  | 2 ++
 src/t_ext4_dax_journal_corruption.c | 2 ++
 src/t_mmap_cow_race.c               | 2 ++
 src/t_mmap_stale_pmd.c              | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/src/t_ext4_dax_inline_corruption.c b/src/t_ext4_dax_inline_corruption.c
index b52bcc0d..e1a39a6c 100644
--- a/src/t_ext4_dax_inline_corruption.c
+++ b/src/t_ext4_dax_inline_corruption.c
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Intel Corporation. */
 #include <errno.h>
 #include <fcntl.h>
 #include <stdio.h>
diff --git a/src/t_ext4_dax_journal_corruption.c b/src/t_ext4_dax_journal_corruption.c
index fccef8f5..ba7a96e4 100644
--- a/src/t_ext4_dax_journal_corruption.c
+++ b/src/t_ext4_dax_journal_corruption.c
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2018 Intel Corporation. */
 #include <errno.h>
 #include <fcntl.h>
 #include <stdio.h>
diff --git a/src/t_mmap_cow_race.c b/src/t_mmap_cow_race.c
index 207ba425..5941fcf3 100644
--- a/src/t_mmap_cow_race.c
+++ b/src/t_mmap_cow_race.c
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2017 Intel Corporation. */
 #include <errno.h>
 #include <fcntl.h>
 #include <libgen.h>
diff --git a/src/t_mmap_stale_pmd.c b/src/t_mmap_stale_pmd.c
index 6a52201c..a139d8ac 100644
--- a/src/t_mmap_stale_pmd.c
+++ b/src/t_mmap_stale_pmd.c
@@ -1,3 +1,5 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (c) 2017 Intel Corporation. */
 #include <errno.h>
 #include <fcntl.h>
 #include <libgen.h>
-- 
2.14.4
