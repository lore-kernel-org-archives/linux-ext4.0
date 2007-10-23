From: Chris Mason <chris.mason@oracle.com>
Subject: Re: compilebench numbers for ext4
Date: Mon, 22 Oct 2007 20:54:31 -0400
Message-ID: <20071022205431.36af2d59@think.oraclecorp.com>
References: <20071022193104.0beafeca@think.oraclecorp.com>
	<1193098378.3807.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:45703 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbXJWA5J (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 22 Oct 2007 20:57:09 -0400
In-Reply-To: <1193098378.3807.24.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 22 Oct 2007 17:12:58 -0700
Mingming Cao <cmm@us.ibm.com> wrote:

> On Mon, 2007-10-22 at 19:31 -0400, Chris Mason wrote:
> > Hello everyone,
> > 
> > I recently posted some performance numbers for Btrfs with different
> > blocksizes, and to help establish a baseline I did comparisons with
> > Ext3.
> > 
> 
> Thanks for doing this, Chris!
> 
> > The graphs, numbers and a basic description of compilebench are
> > here:
> > 
> > http://oss.oracle.com/~mason/blocksizes/
> > 
> > Ext3 easily wins the read phase, but scores poorly while creating
> > files and deleting them.  Since ext3 is winning the read phase, we
> > can assume the file layout is fairly good.  I think most of the
> > problems during the write phase are caused by pdflush doing
> > metadata writeback.  The file data and metadata are written
> > separately, and so we end up seeking between things that are
> > actually close together.
> > 
> > Andreas asked me to give ext4 a try, so I grabbed the patch queue
> > from Friday along with the latest Linus kernel.  The FS was created
> > with:
> > 
> > mkfs.ext3 -I 256 /dev/xxxx
> > mount -o delalloc,mballoc,data=ordered -t ext4dev /dev/xxxx
> > 
> > I did expect delayed allocation to help the write phases of
> > compilebench, especially the parts where it writes out .o files in
> > random order (basically writing medium sized files all over the
> > directory tree).
> 
> Unfortunately delayed allocation support for ordered mode is not there
> yet. 

Sorry, I meant to write data=writeback, not sure how my fingers typed
ordered instead.

> 
> >   But, every phase except reads showed huge
> > improvements.
> > 
> > http://oss.oracle.com/~mason/compilebench/ext4/ext-create-compare.png
> > http://oss.oracle.com/~mason/compilebench/ext4/ext-compile-compare.png
> > http://oss.oracle.com/~mason/compilebench/ext4/ext-read-compare.png
> > http://oss.oracle.com/~mason/compilebench/ext4/ext-rm-compare.png
> > 
> > To match the ext4 numbers with Btrfs, I'd probably have to turn off
> > data checksumming...
> > 
> > But oddly enough I saw very bad ext4 read throughput even when
> > reading a single kernel tree (outside of compilebench).  The time
> > to read the tree was almost 2x ext3.  Have others seen similar
> > problems?
> > 
> thanks for point this out, will run compilebench. 
> 
> Trying to understand the Disk IO graph
> http://oss.oracle.com/~mason/compilebench/ext4/ext-read-compare.png
> it looks like ext3 the blocks are spread over the disk, while ext4 is
> more around the same place, is this right?

It does look like that, but the ext4 movie shows the middle line a
little differently than the graph.  The middle ext4 line is actually
comprised of a lot of seeks.

For comparison, here's the ext3 movie:

http://oss.oracle.com/~mason/compilebench/ext4/ext3-read.mpg

Even though the ext3 data looks more spread out, there are more
throughput peaks, and fewer seeks overall in ext3.

-chris
