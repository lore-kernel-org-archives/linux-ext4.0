From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: compilebench numbers for ext4
Date: Mon, 22 Oct 2007 17:12:58 -0700
Message-ID: <1193098378.3807.24.camel@localhost.localdomain>
References: <20071022193104.0beafeca@think.oraclecorp.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48615 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbXJWAM6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 22 Oct 2007 20:12:58 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l9N0CvIf030125
	for <linux-ext4@vger.kernel.org>; Mon, 22 Oct 2007 20:12:57 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l9N0CvMg101778
	for <linux-ext4@vger.kernel.org>; Mon, 22 Oct 2007 20:12:57 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l9N0CvrJ003104
	for <linux-ext4@vger.kernel.org>; Mon, 22 Oct 2007 20:12:57 -0400
In-Reply-To: <20071022193104.0beafeca@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-10-22 at 19:31 -0400, Chris Mason wrote:
> Hello everyone,
> 
> I recently posted some performance numbers for Btrfs with different
> blocksizes, and to help establish a baseline I did comparisons with
> Ext3.
> 

Thanks for doing this, Chris!

> The graphs, numbers and a basic description of compilebench are here:
> 
> http://oss.oracle.com/~mason/blocksizes/
> 
> Ext3 easily wins the read phase, but scores poorly while creating files
> and deleting them.  Since ext3 is winning the read phase, we can assume
> the file layout is fairly good.  I think most of the problems during the
> write phase are caused by pdflush doing metadata writeback.  The file
> data and metadata are written separately, and so we end up seeking
> between things that are actually close together.
> 
> Andreas asked me to give ext4 a try, so I grabbed the patch queue from
> Friday along with the latest Linus kernel.  The FS was created with:
> 
> mkfs.ext3 -I 256 /dev/xxxx
> mount -o delalloc,mballoc,data=ordered -t ext4dev /dev/xxxx
> 
> I did expect delayed allocation to help the write phases of
> compilebench, especially the parts where it writes out .o files in
> random order (basically writing medium sized files all over the
> directory tree).

Unfortunately delayed allocation support for ordered mode is not there
yet. 

>   But, every phase except reads showed huge
> improvements.
> 
> http://oss.oracle.com/~mason/compilebench/ext4/ext-create-compare.png
> http://oss.oracle.com/~mason/compilebench/ext4/ext-compile-compare.png
> http://oss.oracle.com/~mason/compilebench/ext4/ext-read-compare.png
> http://oss.oracle.com/~mason/compilebench/ext4/ext-rm-compare.png
> 
> To match the ext4 numbers with Btrfs, I'd probably have to turn off data
> checksumming...
> 
> But oddly enough I saw very bad ext4 read throughput even when reading
> a single kernel tree (outside of compilebench).  The time to read the
> tree was almost 2x ext3.  Have others seen similar problems?
> 
thanks for point this out, will run compilebench. 

Trying to understand the Disk IO graph
http://oss.oracle.com/~mason/compilebench/ext4/ext-read-compare.png
it looks like ext3 the blocks are spread over the disk, while ext4 is
more around the same place, is this right?

> I think the ext4 delete times are so much better than ext3 because this
> is a single threaded test.  delayed allocation is able to get
> everything into a few extents, and these all end up in the inode.  So,
> the delete phase only needs to seek around in small directories and
> seek to well grouped inodes.  ext3 probably had to seek all over for
> the direct/indirect blocks.
> 
> So, tomorrow I'll run a few tests with delalloc and mballoc
> independently, but if there are other numbers people are interested in,
> please let me know.
> 
> (test box was a desktop machine with single sata drive, barriers were
> not used).
> 
> -chris
> -
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
