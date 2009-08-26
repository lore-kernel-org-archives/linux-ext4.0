From: Jan Kara <jack@suse.cz>
Subject: Buffer state bits
Date: Wed, 26 Aug 2009 22:00:21 +0200
Message-ID: <20090826200021.GA5716@duck.novell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: linux-fsdevel@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  When working on my page_mkwrite() improvements for blocksize < pagesize,
I've put down a description of buffer state bits (because I was thinking
whether I could you some of them for my purpose). Below is what I've ended
with - suggestions for improvements or even contributions are welcome. I
plan to put this somewhere to Documentation/ once it gets reasonably
complete...
  There are some questions / suggestions for cleanups in there marked with
XXX so opinions on that are also welcome...

								Honza


State bits in buffer heads
==========================

BH_Req
  XXX: Not really used?

BH_Dirty
- Ideally, this bit should mean "buffer has data that have to be written". But
  it is not quite true. The problem happens when someone calls set_page_dirty()
  on the page to which buffers are attached or similarly when buffers are
  attached to a dirty page. Then all buffers attached to the page are marked
  dirty - even those that are beyond end of file which obviously should not
  be written.

  When buffer is dirty, the page has to be dirty as well (mark buffer dirty
  takes care of that). It is not necessarily the other way around and buffer
  dirty bit is what ultimately decides whether the buffer goes to disk or not.

BH_Lock
- Used as bit spinlock. Buffer is locked when it is submitted for IO and unlocked
  when the IO finishes. It is used by other places to protect against IO happening
  on the buffer (e.g. when copying new data into the buffer etc.).

BH_Uptodate
- Buffer contains data that can be trusted. Generally, this flag means that
  what is stored in memory is at least as new as what is stored on disk in the
  corresponding block (if it has already been allocated). For buffers that are
  covering a hole and user has not yet written to it, the flags means the buffer
  is correctly filled with zeros. Buffers beyond the end of file are the only
  ones where the contents actually cannot be trusted even though BH_Uptodate bit
  is set. User can mmap the last page of the file and write even to buffers
  beyond EOF attached to this page.  So these buffers can contain anything
  although one might expect them to contain zeros.

  The flag is set in end_io handlers (under buffer lock) and in other places
  copying data into the buffer / page (under a page lock for data buffers and
  buffer lock for metadata buffers). The bit is cleared in end_io handlers when
  the IO failed.  The problem with this is that when the failing IO was write,
  the resulting buffer state is not accurate since the buffer holds newer data
  than are on disk. Long term, we want to get rid of clearing uptodate bit on
  failed write so use BH_Write_EIO for write error detection in new code.

BH_Mapped
- Buffer has a physical block backing it stored in b_bdev + b_blocknr. This bit
  is set by filesystem's get_block() function (or by VFS itself for block device
  mappings).

  XXX: Some filesystems set BH_Mapped even for buffers that do no really
  have the backing block (like buffers for delayed allocation). I think
  we should get rid of it...

BH_New
- Buffer is freshly allocated. This flag is usually set by filesystem's
  get_block function when it freshly allocates block backing the buffer.
  VFS then takes care of calling unmap_underlying_metadata on the buffer
  and zeroing out the buffer. When all is done, the flag is cleared. So
  this flag should not be seen set after we drop a page lock.

  Note that because of unmap_underlying_metadata call, buffer has to be
  mapped when BH_New is set. That is part of the reason why some filesystems
  map delayed-allocated buffer to some bogus block - they want VFS to do the
  zeroing but do not have a real block to map the buffer to yet.

BH_Delay
- Allocation of physical block backing the buffer is delayed. This flag is set
  by filesystem's get_block function to mark that filesystem knows that this
  buffer needs to get written (usually space is reserved for the buffer) but
  it does not have physical block assigned yet - that usually happens when
  memory management decides to write out dirty data or we have to write out
  the page for other reason (like if fsync has been called).

  XXX: Currently, the handling of delayed buffers in VFS is kind of convoluted
  because delayed buffers are mapped. If they wouldn't be, VFS wouldn't need
  to care about this bit at all.

BH_Unwritten
- Used by a filesystem to mark that although buffer is not dirty, it contains
  data different from those on disk. This is usually used by a filesystem to
  mark buffers whose backing blocks are not initialized to zeros and do not
  want VFS to load the junk from disk

  XXX: Do we need this flag at all? If filesystem's get_block function just
  marked the buffer as uptodate and
  a) zeroed it out in the read case
  b) marked it as new in the write case (we could zero out the buffer here
     as well, which would be cleaner but it would be unnecessary for buffers
     to which data will be written immediately afterwards).
  It would have exactly the same effect as BH_Unwritten flag has.

BH_Async_Read
- Buffer is being read from disk. This is used by async reading code. When a
  page should be read from disk, all mapped buffers in it are marked with this
  flag.  When IO on the buffer finishes, end_io handler (end_buffer_async_read)
  clears the flag and checks whether all the buffers in the page have the flag
  cleared. If so, it marks the page as uptodate and unlocks it.

BH_Async_Write
- Buffer is being written to disk. This is used by async writing code. When a
  page should be written to disk, all buffers to be written are marked with
  this flag.  When IO on the buffer finishes, end_io handler (usually
  end_buffer_async_write) clears the flag anch checks whether all the buffers in
  the page have the flag cleared. If so, it ends writeback on the page.

BH_Uptodate_Lock
- Used as bit spinlock by end_buffer_async_read and end_buffer_async_write to
  synchronize checking of BH_Async_Read and BH_Async_Write flags.

BH_Boundary
- Set by the filesystem to indicate that the next block on the media is probably
  going to contain metadata. The flag is used by code in __mpage_writepage() to
  submit the next block on the media for write (if it is dirty) to optimize
  writeout pattern in a common case when the layout on disk looks like:
    D|D|D|M|D|D|D (where D is a data block and M a block containing metadata
  needed to access further data).

BH_Write_EIO
- IO error happened when we tried to write the buffer. This flag is set when
  write of the buffer fails. The flag is cleared each time we submit the buffer
  for write. The flag is used mainly to pass down the information to the
  filesystem. When the buffer with this flag set should be dropped from memory,
  we set AS_EIO flag on the mapping this buffer belongs to or on b_assoc_map if
  set.

BH_Ordered
- Buffer is an IO barrier (see Documentation/block/barrier.txt)

BH_Eopnotsupp
- Set when the IO request ended with EOPNOTSUPP. Currently this only happens
  when the buffer has been submitted with BH_Ordered bit set and the underlying
  device does not support IO barriers. This flags is used to pass the information
  down to the filesystems so that they can somehow handle the situation.

BH_Quiet
- Do not print error message when error happened. Set when BIO_QUIET bit was set.
  XXX: Never cleared?!?
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
