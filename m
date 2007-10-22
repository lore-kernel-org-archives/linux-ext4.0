From: Chris Mason <chris.mason@oracle.com>
Subject: compilebench numbers for ext4
Date: Mon, 22 Oct 2007 19:31:04 -0400
Message-ID: <20071022193104.0beafeca@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:22736 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715AbXJVXcc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Oct 2007 19:32:32 -0400
Received: from agmgw2.us.oracle.com (agmgw2.us.oracle.com [152.68.180.213])
	by agminet01.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id l9MNWQ6Z008530
	for <linux-ext4@vger.kernel.org>; Mon, 22 Oct 2007 18:32:26 -0500
Received: from acsmt355.oracle.com (acsmt355.oracle.com [141.146.40.155])
	by agmgw2.us.oracle.com (Switch-3.2.0/Switch-3.2.0) with ESMTP id l9LIJicM030200
	for <linux-ext4@vger.kernel.org>; Mon, 22 Oct 2007 17:32:26 -0600
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hello everyone,

I recently posted some performance numbers for Btrfs with different
blocksizes, and to help establish a baseline I did comparisons with
Ext3.

The graphs, numbers and a basic description of compilebench are here:

http://oss.oracle.com/~mason/blocksizes/

Ext3 easily wins the read phase, but scores poorly while creating files
and deleting them.  Since ext3 is winning the read phase, we can assume
the file layout is fairly good.  I think most of the problems during the
write phase are caused by pdflush doing metadata writeback.  The file
data and metadata are written separately, and so we end up seeking
between things that are actually close together.

Andreas asked me to give ext4 a try, so I grabbed the patch queue from
Friday along with the latest Linus kernel.  The FS was created with:

mkfs.ext3 -I 256 /dev/xxxx
mount -o delalloc,mballoc,data=ordered -t ext4dev /dev/xxxx

I did expect delayed allocation to help the write phases of
compilebench, especially the parts where it writes out .o files in
random order (basically writing medium sized files all over the
directory tree).  But, every phase except reads showed huge
improvements.

http://oss.oracle.com/~mason/compilebench/ext4/ext-create-compare.png
http://oss.oracle.com/~mason/compilebench/ext4/ext-compile-compare.png
http://oss.oracle.com/~mason/compilebench/ext4/ext-read-compare.png
http://oss.oracle.com/~mason/compilebench/ext4/ext-rm-compare.png

To match the ext4 numbers with Btrfs, I'd probably have to turn off data
checksumming...

But oddly enough I saw very bad ext4 read throughput even when reading
a single kernel tree (outside of compilebench).  The time to read the
tree was almost 2x ext3.  Have others seen similar problems?

I think the ext4 delete times are so much better than ext3 because this
is a single threaded test.  delayed allocation is able to get
everything into a few extents, and these all end up in the inode.  So,
the delete phase only needs to seek around in small directories and
seek to well grouped inodes.  ext3 probably had to seek all over for
the direct/indirect blocks.

So, tomorrow I'll run a few tests with delalloc and mballoc
independently, but if there are other numbers people are interested in,
please let me know.

(test box was a desktop machine with single sata drive, barriers were
not used).

-chris
