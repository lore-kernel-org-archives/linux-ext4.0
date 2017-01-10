From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v4 0/7] DAX tracepoints, mm argument simplification
Date: Tue, 10 Jan 2017 14:52:15 -0700
Message-ID: <1484085142-2297-1-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
 Matthew Wilcox <mawilcox-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>,
 linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
 Andreas Dilger <adilger.kernel-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>,
 Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
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

Andrew,

This contains both my DAX tracepoint code and Dave Jiang's MM argument
simplifications.  Dave's code was written with my tracepoint code as a
baseline, so it seemed simplest to keep them together in a single series.

This series is based on the v4.10-rc3-mmots-2017-01-09-17-08 snapshot.  A
working tree can be found here:

https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=mmots_dax_tracepoint

Changes from the previous versions of these patches:
 - Combined Dave's code and mine into a single series.
 - Resolved some minor merge conflics in Dave's patches so they could be
   applied to the latest mmots snapshot.
 - Added Reviewed-by and Acked-by tags to patches as appropriate.

My goal for this series is to get it merged for v4.11.

Thanks,
- Ross

Dave Jiang (2):
  mm, dax: make pmd_fault() and friends to be the same as fault()
  mm, dax: move pmd_fault() to take only vmf parameter

Ross Zwisler (5):
  tracing: add __print_flags_u64()
  dax: add tracepoint infrastructure, PMD tracing
  dax: update MAINTAINERS entries for FS DAX
  dax: add tracepoints to dax_pmd_load_hole()
  dax: add tracepoints to dax_pmd_insert_mapping()

 MAINTAINERS                   |   5 +-
 drivers/dax/dax.c             |  26 ++++---
 fs/dax.c                      | 114 ++++++++++++++++--------------
 fs/ext4/file.c                |  13 ++--
 fs/xfs/xfs_file.c             |  15 ++--
 include/linux/dax.h           |   6 +-
 include/linux/mm.h            |  28 +++++++-
 include/linux/pfn_t.h         |   6 ++
 include/linux/trace_events.h  |   4 ++
 include/trace/events/fs_dax.h | 156 ++++++++++++++++++++++++++++++++++++++++++
 include/trace/trace_events.h  |  11 +++
 kernel/trace/trace_output.c   |  38 ++++++++++
 mm/memory.c                   |  11 ++-
 13 files changed, 338 insertions(+), 95 deletions(-)
 create mode 100644 include/trace/events/fs_dax.h

-- 
2.7.4
