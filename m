From: Suparna Bhattacharya <suparna@in.ibm.com>
Subject: Re: ext3 sequential read performance (~20%) degrade
Date: Fri, 15 Sep 2006 11:20:05 +0530
Message-ID: <20060915055005.GA12172@in.ibm.com>
References: <1158276972.24991.10.camel@dyn9047017100.beaverton.ibm.com> <20060914170308.9595141c.akpm@osdl.org>
Reply-To: suparna@in.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Badari Pulavarty <pbadari@us.ibm.com>, sct@redhat.com,
	ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:62853 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750772AbWIOFsk (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Fri, 15 Sep 2006 01:48:40 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8F5mcsq019617
	for <linux-ext4@vger.kernel.org>; Fri, 15 Sep 2006 01:48:38 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8F5mdQt282332
	for <linux-ext4@vger.kernel.org>; Fri, 15 Sep 2006 01:48:39 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8F5mckn008987
	for <linux-ext4@vger.kernel.org>; Fri, 15 Sep 2006 01:48:39 -0400
To: Andrew Morton <akpm@osdl.org>
Content-Disposition: inline
In-Reply-To: <20060914170308.9595141c.akpm@osdl.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 14, 2006 at 05:03:08PM -0700, Andrew Morton wrote:
> On Thu, 14 Sep 2006 16:36:12 -0700
> Badari Pulavarty <pbadari@us.ibm.com> wrote:
> 
> > Hi Andrew,
> > 
> > I have been working on tracking down ~20% performance degrade for
> > sequential read performance for ext3. 
> 
> oop.  I'd kinda prefer that we discover things like this before the patch
> gets into mainline.
> 
> > Finally narrowed it down to get_blocks() support. If I force
> > ext3_get_blocks_handle() to always return 1 block - I get better
> > IO rate. I did all the usual stuff, tracked down requests, traced
> > blocksizes, looked at readahead code, looked at mpage_readpages()
> > etc.. I still can't figure out how to explain the degrade..
> > 
> > Any suggestions on how to track it down.
> 
> Learn to driver Jens's blktrace stuff, find out why the IO scheduling went
> bad.
> 
> Number one suspicion: the buffer_boundary() stuff isn't working.

I think you are right about that  - perhaps something along
the lines of the following patch (untested) would help ?

If this is the problem then I guess the degradation should show up for DIO
as well. 

-----------------------------

The boundary block check in ext3_get_blocks_handle needs to be adjusted
against the count of blocks mapped in this call, now that it can map
more than one block.



 linux-2.6.18-rc5-suparna/fs/ext3/inode.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ext3/inode.c~ext3-multiblock-boundary-fix fs/ext3/inode.c
--- linux-2.6.18-rc5/fs/ext3/inode.c~ext3-multiblock-boundary-fix	2006-09-15 10:53:12.000000000 +0530
+++ linux-2.6.18-rc5-suparna/fs/ext3/inode.c	2006-09-15 10:54:30.000000000 +0530
@@ -925,7 +925,7 @@ int ext3_get_blocks_handle(handle_t *han
 	set_buffer_new(bh_result);
 got_it:
 	map_bh(bh_result, inode->i_sb, le32_to_cpu(chain[depth-1].key));
-	if (blocks_to_boundary == 0)
+	if (count > blocks_to_boundary)
 		set_buffer_boundary(bh_result);
 	err = count;
 	/* Clean up and exit */

_

Regards
Suparna

-- 
Suparna Bhattacharya (suparna@in.ibm.com)
Linux Technology Center
IBM Software Lab, India


