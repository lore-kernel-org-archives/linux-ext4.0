From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: iomap preparations for GFS2 v2
Date: Tue, 19 Jun 2018 17:14:31 +0200
Message-ID: <CAHc6FU4DWqFVpJE9SJvPbABgbH0goSG9ByFRD2YA1ydLF8_wYA@mail.gmail.com>
References: <20180614120457.28285-1-hch@lst.de>
	<CAHc6FU4nQ562SxepV1=dqcuuuPBWOTXr4sAiY_5H-Z7uOaTNng@mail.gmail.com>
	<20180615080326.GB19525@lst.de>
	<5a1e303b-e96e-7faf-1bcd-36d63a237514@redhat.com>
	<CAHc6FU79WMraW95k-p_2x8GF_dtmDBST50D=3joYAua2KBtOqw@mail.gmail.com>
	<20180619143550.GA15162@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: linux-xfs@vger.kernel.org, cluster-devel <cluster-devel@redhat.com>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: Christoph Hellwig <hch@lst.de>
Return-path: <cluster-devel-bounces@redhat.com>
In-Reply-To: <20180619143550.GA15162@lst.de>
List-Unsubscribe: <https://www.redhat.com/mailman/options/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/cluster-devel>
List-Post: <mailto:cluster-devel@redhat.com>
List-Help: <mailto:cluster-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/cluster-devel>,
	<mailto:cluster-devel-request@redhat.com?subject=subscribe>
Sender: cluster-devel-bounces@redhat.com
Errors-To: cluster-devel-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On 19 June 2018 at 16:35, Christoph Hellwig <hch@lst.de> wrote:
> On Tue, Jun 19, 2018 at 01:08:12PM +0200, Andreas Gruenbacher wrote:
>> What I'm seeing in the readpage address space operation is pages which
>> are not PageUptodate(), with a page-size buffer head that is
>> buffer_uptodate(). The filesystem doesn't bother keeping the page
>> flags in sync with the buffer head flags, nothing unusual.
>
> It is in fact highly unusual, as all the generic routines do set
> the page uptodate once all buffers are uptodate.
>
>> When
>> iomap_readpage is called on such a page, it will replace the current
>> contents with what's on disk, losing the changes in memory. So we
>> cannot just call iomap_readpages, we need to check the buffer head
>> flags as well. Or, since the old code is still needed for page size !=
>> block size anyway, we can fall back to that for pages that have
>> buffers for now.
>
> I'd like to understand where that buffer_head comes from, something
> seems fishy here.

Ok, here is one test case that triggered the problem for me.

Starting from commit bd926eb58b13 on the iomap-readpage branch,

  https://git.kernel.org/pub/scm/linux/kernel/git/gfs2/linux-gfs2.git/log/?h=iomap-readpage

with this patch on top which causes iomap_readpage to be called even
for pages with buffers:

--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -511,8 +511,7 @@ static int __gfs2_readpage(void *file, struct page *page)

        int error;

-       if (i_blocksize(page->mapping->host) == PAGE_SIZE &&
-           !page_has_buffers(page)) {
+       if (i_blocksize(page->mapping->host) == PAGE_SIZE) {
                error = iomap_readpage(page, &gfs2_iomap_ops);
        } else if (gfs2_is_stuffed(ip)) {
                error = stuffed_readpage(ip, page);

The following fsx operations, stored as junk.fsxops:

  write 0x11400 0x1800 0x6e6d4 *
  punch_hole 0xfa7a 0x2410 0x0 *
  mapread 0xd000 0x78ea 0x34200 *

Can be replayed as:

  # mkfs.gfs2 -O -b 4096 -p lock_nolock $DEV
  # mount $DEV $MNT
  # ltp/fsx -N 10000 -o 32768 -l 500000 -r 4096 -t 512 -w 512 -Z -W
--replay-ops junk.fsxops $MNT/junk

(Most of the above fsx options could probably be removed ...)

The hole in this example is unaligned, so punch_hole will zero the end
of the first as well as the beginning of the last page of the hole.
This will leave at least the last page of the hole as not
PageUptodate(), with a buffer_uptodate() buffer head. The mapread will
call into iomap_readpage. Because the page has buffers, the
WARN_ON_ONCE(page_has_buffers(page)) in iomap_readpage will trigger.
And iomap_readpage will reread the page from disk, overwriting the
zeroes written by punch_hole. This will cause fsx to complain because
it doesn't see the zeroes it expects.

This could be a bug in __gfs2_punch_hole => gfs2_block_zero_range as
well, but it's not clear to me how.

Andreas
