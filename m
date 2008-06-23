From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Performance of ext4
Date: Mon, 23 Jun 2008 23:15:08 +0530
Message-ID: <20080623174508.GA7216@skywalker>
References: <Pine.LNX.4.64.0806130753100.7097@diagnostix.dwd.de> <20080616175408.GF3279@atrey.karlin.mff.cuni.cz> <20080616181353.GA20686@skywalker> <Pine.LNX.4.64.0806171001200.6307@diagnostix.dwd.de> <20080619155645.GA8582@mit.edu> <485A8C2D.1090806@redhat.com> <20080619174211.GB9119@mit.edu> <Pine.LNX.4.64.0806200812340.3383@diagnostix.dwd.de> <20080620085922.GH9119@mit.edu> <Pine.LNX.4.64.0806200905070.3383@diagnostix.dwd.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
	Jan Kara <jack@suse.cz>, Solofo.Ramangalahy@bull.net,
	Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:56438 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752976AbYFWRpw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Jun 2008 13:45:52 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806200905070.3383@diagnostix.dwd.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jun 20, 2008 at 09:21:48AM +0000, Holger Kiehl wrote:
> On Fri, 20 Jun 2008, Theodore Tso wrote:
>
>> On Fri, Jun 20, 2008 at 08:32:52AM +0000, Holger Kiehl wrote:
>>>> It sounds like i_size is actually dropping in
>>>> size at some pointer long after the file was written.  If I had to
>>
>> sorry, "at some point"...
>>
>>>> guess the value in the inode cache is correct; and perhaps so is the
>>>> value on the journal.  But somehow, the wrong value is getting written
>>>> to disk
>>
>> Or, "the right value is never getting written to disk".  (Which as I
>> think about it is more likely; it's likely that an update to i_size is
>> getting *lost*, perhaps because the delalloc code is possibly
>> modifying i_size without starting a transaction first.  Again this is
>> just a guess.)
>>
>>> What I find strange is that the missing parts of the file are not for
>>> example exactly 512 or 1024 or 4096 bytes it is mostly some odd number
>>> of bytes.
>>
>> Is there any chance the truncation point is related to how the program
>> is writing its output file?  i.e., if it is a text file, is the
>> truncation happening after a new-line or when the stdio library might
>> have done an explicit or implicit fflush()?
>>
> When the benchmark runs it writes to stdout and with tee to the result
> file. It first writes some information about the system, prepares the
> test files (creates lots of small files), calls sync and then starts
> the test. Then every minute one line gets written to the result file.
> Often I have seen that everything after the sync was missing. But
> sometimes it happened that some parts at the end are missing. But it
> was always a clean cut, that is there where no lines that where cut
> partially. The lines where always complete.
>

I found one place where we fail to update i_disksize. Can you try this
patch ?

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 33f940b..9fa737f 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1620,7 +1620,10 @@ static int ext4_da_writepage(struct page *page,
 	loff_t size;
 	unsigned long len;
 	handle_t *handle = NULL;
+	ext4_lblk_t block;
+	loff_t disksize;
 	struct buffer_head *page_bufs;
+	struct buffer_head *bh, *head;
 	struct inode *inode = page->mapping->host;
 
 	handle = ext4_journal_current_handle();
@@ -1662,6 +1665,38 @@ static int ext4_da_writepage(struct page *page,
 	else
 		ret = block_write_full_page(page, ext4_da_get_block_write, wbc);
 
+	 if (ret)
+		 return ret;
+	/*
+	 * When called via shrink_page_list and if we don't have any unmapped
+	 * buffer_head we still could have written some new content in an
+	 * already mapped buffer. That means we need to extent i_disksize here
+	 */
+	/* Find the last logical block number in the page. */
+	block = (sector_t)page->index << (PAGE_CACHE_SHIFT - inode->i_blkbits);
+	bh = head = page_buffers(page);
+	do {
+		bh = bh->b_this_page;
+		block++;
+	} while (bh != head);
+
+	disksize = ((loff_t) block) << inode->i_blkbits;
+	if (disksize > i_size_read(inode))
+		disksize = i_size_read(inode);
+	if (disksize > EXT4_I(inode)->i_disksize) {
+		/*
+		 * XXX: replace with spinlock if seen contended -bzzz
+		 */
+		down_write(&EXT4_I(inode)->i_data_sem);
+		if (disksize > EXT4_I(inode)->i_disksize)
+			EXT4_I(inode)->i_disksize = disksize;
+		up_write(&EXT4_I(inode)->i_data_sem);
+
+		if (EXT4_I(inode)->i_disksize == disksize) {
+			ret = ext4_mark_inode_dirty(handle, inode);
+			return ret;
+		}
+	}
 	return ret;
 }
 
