From: Curt Wohlgemuth <curtw@google.com>
Subject: Bug in extent zeroout: blocks not marked as new
Date: Mon, 23 Nov 2009 10:17:46 -0800
Message-ID: <6601abe90911231017q5cf424a4s4e6c788922c336c8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.45.13]:25538 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbZKWSRp (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Nov 2009 13:17:45 -0500
Received: from zps19.corp.google.com (zps19.corp.google.com [172.25.146.19])
	by smtp-out.google.com with ESMTP id nANIHo3r017691
	for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2009 10:17:51 -0800
Received: from pxi1 (pxi1.prod.google.com [10.243.27.1])
	by zps19.corp.google.com with ESMTP id nANIHmx1014598
	for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2009 10:17:48 -0800
Received: by pxi1 with SMTP id 1so4231079pxi.32
        for <linux-ext4@vger.kernel.org>; Mon, 23 Nov 2009 10:17:48 -0800 (PST)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

I believe I've found a bug in ext4's extent conversion design that results
in block corruption in inodes using previously freed up metadata blocks.

Yes, this is similar to earlier related corruptions we've seen, but this
turned out to be far nastier to detect and analyze.  All the corruptions
were simply blocks of all zeroes -- there was no signature data pattern that
would lead to a source of the corruption.

The problem is that, during conversion of extents from uninitialized to
initialized, ext4 will at some point decide that the remaining uninitialized
extent is too small to split, and will just write zeroes for it, and mark it
as initialized.  This is fine -- until blocks from this "14-block tail
extent" are returned from ext4_ext_get_blocks().

The problem is that, since these blocks are not from an uninitialized
extent, the aren't marked as "new" -- i.e., set_buffer_new() is not called
on bh_result -- and the callers further up in the call stack don't call
unmap_underlying_metadata() on them.

(I've finally got around to understanding that the handling of old dirty
metadata blocks is ultimately handled on the allocating side, not on the
freeing side.  Although bforget() is called on freed up metadata blocks,
because bforget() doesn't lock the buffer before it clears the dirty bit,
there's a known race with the writeout path in __block_write_full_page().
I've seen this race, and seen a block that's had bforget() called on it be
written to disk.)

Handling of old metadata blocks is supposed to be dealt with on the
allocation side, when unmap_underlying_metadata() is called for buffers
marked new on return from the get_block callback.  But this won't get called
for blocks in an extent created with ext4_ext_zeroout().

This is why every corruption we've seen has been a block residing in a
"14-block tail extent" in a newly written file.

I've verified that blocks returned to do_direct_IO() that are in a 14-block
zeroout extent do *not* have unmap_underlying_metadata() called for them.
The same should be the case with buffered I/O as well.

The fix for this is difficult, though.  The simplest thing I can think of is
to stop calling ext4_ext_zeroout() at all; easily done by setting
EXT4_EXT_ZERO_LEN to 0.  But I'm not at all sure of the ramifications of
this.  How expensive is extent split/initialization, especially in light of
Mingming's recent patches in this area?

The other obvious solution is to call unmap_underlying_metadata() at the
time that we zeroout the blocks.

Thoughts?

Thanks,
Curt
