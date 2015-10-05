From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [REGRESSION] 998ef75ddb and aio-dio-invalidate-failure w/
 data=journal
Date: Mon, 5 Oct 2015 11:04:35 -0700
Message-ID: <5612BBB3.7010201@intel.com>
References: <20151005152236.GA8140@thunk.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000607020101010302050906"
To: Theodore Ts'o <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151005152236.GA8140@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

This is a multi-part message in MIME format.
--------------000607020101010302050906
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

I managed to catch the condition in an ftrace.  Full spew is below.

We can see that the iov_iter_copy_from_user_atomic() "failed" and ended
up with a copied=0 which we can see in the ext4_journalled_write_end()
tracepoint as "copied 0".

So we're in this code with copied=0 and len=4096:

> static int ext4_journalled_write_end(struct file *file, ... unsigned copied, ...
> {
...

>         else {
>                 if (copied < len) {
>                         if (!PageUptodate(page))
>                                 copied = 0;
>                         page_zero_new_buffers(page, from+copied, to);
>                 }
> 
>                 ret = ext4_walk_page_buffers(handle, page_buffers(page), from,
>                                              to, &partial, write_end_fn);
>                 if (!partial)
>                         SetPageUptodate(page);
>         }


The warning comes out of ext4_walk_page_buffers() and the dirty state
comes from page_zero_new_buffers(). That seems a _bit_ goofy that the
filesystem is marking the page dirty and then so shortly warning about it.

If we either come in here with copied=0 or force it (when
!PageUptodate()) we are essentially telling the caller that its write
must be repeated. We have no data in the buffer to preserve and we are
not leaking any data we are not marking it Uptodate.

The very lightly tested attached patch gets rid of the "Spotted dirty
metadata buffer" messages that I've been getting testing like this:

	mount -o data=journal /dev/sda1 /mnt/sda1
	TEST_DIR=/mnt/sda1 TEST_DEV=/dev/sda1 ./tests/generic/208

It _seems_ like a relatively sane thing to do.

>>  2)  aio-dio-3204  |               |              ext4_journalled_write_end() {
>>  2)  aio-dio-3204  |               |                /* ext4_journalled_write_end: dev 8,1 ino 12 pos 0 len 4096 copied 0 */
>>  2)  aio-dio-3204  |               |                page_zero_new_buffers() {
>>  2)  aio-dio-3204  |               |                  mark_buffer_dirty() {
>>  2)  aio-dio-3204  |               |                    /* block_dirty_buffer: 8,1 sector=34356 size=4096 */
>>  2)  aio-dio-3204  |   0.025 us    |                    page_mapping();
>>  2)  aio-dio-3204  |               |                    __set_page_dirty.constprop.46() {
>>  2)  aio-dio-3204  |   0.026 us    |                      _raw_spin_lock_irqsave();
>>  2)  aio-dio-3204  |               |                      account_page_dirtied() {
>>  2)  aio-dio-3204  |               |                        /* writeback_dirty_page: bdi 8:0: ino=12 index=0 */
>>  2)  aio-dio-3204  |               |                        __inc_zone_page_state() {
>>  2)  aio-dio-3204  |   0.030 us    |                          __inc_zone_state();
>>  2)  aio-dio-3204  |   0.211 us    |                        }
>>  2)  aio-dio-3204  |               |                        __inc_zone_page_state() {
>>  2)  aio-dio-3204  |   0.024 us    |                          __inc_zone_state();
>>  2)  aio-dio-3204  |   0.211 us    |                        }
>>  2)  aio-dio-3204  |   1.085 us    |                      }
>>  2)  aio-dio-3204  |   0.033 us    |                      _raw_spin_unlock_irqrestore();
>>  2)  aio-dio-3204  |   1.727 us    |                    }
>>  2)  aio-dio-3204  |               |                    __mark_inode_dirty() {
>>  2)  aio-dio-3204  |               |                      /* writeback_mark_inode_dirty: bdi 8:0: ino=12 state=I_DIRTY_SYNC|I_DIRTY_DATASYNC|I_DIRTY_PAGES flags=I_DIRTY_PAGES */
>>  2)  aio-dio-3204  |   0.207 us    |                    }
>>  2)  aio-dio-3204  |   2.600 us    |                  }
>>  2)  aio-dio-3204  |   2.878 us    |                }
>>  2)  aio-dio-3204  |               |                ext4_walk_page_buffers() {
>>  2)  aio-dio-3204  |               |                  write_end_fn() {
>>  2)  aio-dio-3204  |               |                    __ext4_handle_dirty_metadata() {
>>  2)  aio-dio-3204  |   0.024 us    |                      _cond_resched();
>>  2)  aio-dio-3204  |               |                      jbd2_journal_dirty_metadata() {
>>  2)  aio-dio-3204  |   0.025 us    |                        _raw_spin_lock();
>>  2)  aio-dio-3204  |               |                        __jbd2_journal_file_buffer() {
>>  2)  aio-dio-3204  |               |                          warn_dirty_buffer.isra.10() {
>>  2)  aio-dio-3204  |               |                            bdevname() {
>>  2)  aio-dio-3204  | + 15.280 us   |                              disk_name();
>>  2)  aio-dio-3204  | + 15.661 us   |                            }
>>  2)  aio-dio-3204  |               |                            /* ^A4JBD2: Spotted dirty metadata buffer (dev = sda1, blocknr = 34356). There's a risk of filesystem corruption in case of system crash. */
>>  2)  aio-dio-3204  |               |                            bdevname() {
>>  2)  aio-dio-3204  |   0.080 us    |                              disk_name();
>>  2)  aio-dio-3204  |   0.298 us    |                            }


--------------000607020101010302050906
Content-Type: text/x-patch;
 name="ext4-regression-2015-10-05-0.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ext4-regression-2015-10-05-0.patch"

diff -puN fs/ext4/inode.c~debug-dont-prefault-on-write fs/ext4/inode.c
--- a/fs/ext4/inode.c~debug-dont-prefault-on-write	2015-10-05 10:12:35.286153137 -0700
+++ b/fs/ext4/inode.c	2015-10-05 10:50:37.372253050 -0700
@@ -1204,10 +1204,20 @@ static int ext4_journalled_write_end(str
 		copied = ext4_write_inline_data_end(inode, pos, len,
 						    copied, page);
 	else {
+		/*
+		 * With a short write (copied < len) we have potentially
+		 * valuable data in 'page'.  But, when the page is made Uptodate
+		 * this data will be overwritten.  Setting copied=0 will tell
+		 * the upper layers to repeat the write to 'page'.
+		 *
+		 * Only bother zeroing out buffers when we have _actually_
+		 * written data.
+		 */
 		if (copied < len) {
 			if (!PageUptodate(page))
 				copied = 0;
-			page_zero_new_buffers(page, from+copied, to);
+			if (copied)
+				page_zero_new_buffers(page, from+copied, to);
 		}
 
 		ret = ext4_walk_page_buffers(handle, page_buffers(page), from,
_

--------------000607020101010302050906--
