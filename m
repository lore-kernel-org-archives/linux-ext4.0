From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 0/2] ext4: fix DAX dma vs truncate/hole-punch
Date: Wed, 27 Jun 2018 15:22:50 -0600
Message-ID: <20180627212252.31032-1-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>,
 "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
 Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org,
 Jeff Moyer <jmoyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
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

This series from Dan:

https://lists.01.org/pipermail/linux-nvdimm/2018-March/014913.html

added synchronization between DAX dma and truncate/hole-punch in XFS.
This short series adds analogous support to ext4.

I've added calls to ext4_break_layouts() everywhere that ext4 removes
blocks from an inode's map.

The timings in XFS are such that it's difficult to hit this race.  Dan
was able to show the race by manually introducing delays in the direct
I/O path.

For ext4, though, its trivial to hit this race, and a hit will result in
a trigger of this WARN_ON_ONCE() in dax_disassociate_entry():

        WARN_ON_ONCE(trunc && page_ref_count(page) > 1);

I've made an xfstest which tests all the paths where we now call
ext4_break_layouts(). Each of the four paths easily hits this race many
times in my test setup with the xfstest.  You can find that test here:

https://lists.01.org/pipermail/linux-nvdimm/2018-June/016435.html

With these patches applied, I've still seen occasional hits of the above
WARN_ON_ONCE(), which tells me that we still have some work to do.  I'll
continue looking at these more rare hits.

--- 

Changes in v2:
 * A little cleanup to each patch as suggested by Jan.
 * Removed the ext4_break_layouts() call in ext4_truncate_failed_write()
   and added a comment instead. (Jan)
 * Added reviewed-by tags from Jan.

Ross Zwisler (2):
  dax: dax_layout_busy_page() warn on !exceptional
  ext4: handle layout changes to pinned DAX mappings

 fs/dax.c           | 10 +++++++++-
 fs/ext4/ext4.h     |  1 +
 fs/ext4/extents.c  | 12 ++++++++++++
 fs/ext4/inode.c    | 46 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/truncate.h |  4 ++++
 5 files changed, 72 insertions(+), 1 deletion(-)

-- 
2.14.4
