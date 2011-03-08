From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH] ext4: Use single thread to perform DIO unwritten
 convertion
Date: Mon, 07 Mar 2011 17:40:51 -0800
Message-ID: <1299548451.2526.279.camel@mingming-laptop>
References: <1299180594.2826.6.camel@mingming-laptop>
	 <20110305174639.GD11120@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Eric Whitney <eric.whitney@hp.com>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:55724 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753779Ab1CHBkz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 Mar 2011 20:40:55 -0500
Received: from d01dlp01.pok.ibm.com (d01dlp01.pok.ibm.com [9.56.224.56])
	by e6.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p281GbC2021062
	for <linux-ext4@vger.kernel.org>; Mon, 7 Mar 2011 20:16:37 -0500
Received: from d01relay06.pok.ibm.com (d01relay06.pok.ibm.com [9.56.227.116])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 770B338C803B
	for <linux-ext4@vger.kernel.org>; Mon,  7 Mar 2011 20:40:52 -0500 (EST)
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay06.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p281es5n2469914
	for <linux-ext4@vger.kernel.org>; Mon, 7 Mar 2011 20:40:54 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p281er1E016452
	for <linux-ext4@vger.kernel.org>; Mon, 7 Mar 2011 20:40:53 -0500
In-Reply-To: <20110305174639.GD11120@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2011-03-05 at 12:46 -0500, Ted Ts'o wrote: 
> On Thu, Mar 03, 2011 at 11:29:54AM -0800, Mingming Cao wrote:
> > While running ext4 testing on multiple core, we found there are per
> > cpu ext4-dio-unwritten threads processing conversion from unwritten
> > extents to written for IOs completed from async direct IO patch.
> > Per filesystem is enough, we don't need per cpu threads to work on
> > conversion.
> > 
> > Signed-off-by: Mingming Cao <cmm@us.ibm.com>
> 
> Eric, would you be able to do a very quick sanity check on your
> 48-core machine?  I can definitely see how having a huge number of
> threads per file system could be problematic, especially on a system
> with 32 or 64 ext4 file systems.  I'm curious though if we'll end up
> taking a performance hit on direct I/O workloads.
> 
> If I remember correctly we currently have large file create with DIO
> turned off, right?  Would it be possible to do a large file create
> with DIO enabled, and do a quick run both with and without this patch?
> 
The background thread performs the conversion when IOs from async dio
writing to holes/preallocated is completed. So would need to setup
fallocated files and running async and direct IO would possible to
exercise any potential scalability issue with the background dio
conversion thread... 

I took a look at FFSB, it doesn't support fallocate and async IO yet.
But fio does support aio and fallocate. This is a simple fio profile I
use for test file being setup by fallocate() and run random aio dio over
it. See it is useful for Eric to give it a try or a reference on his 48
core.

examples$ cat aio-setup 
; Random read/write to fallocat files with aio dio
[global]
ioengine=libaio
direct=1
rw=randrw
bs=4k
size=2m
filesize=1024m
fallocate=1
directory=/tmp

[file1]
iodepth=4

> In the future it would also be interesting to see how we are doing
> versus other file systems using a DIO workload.  This is a probably
> another area where I suspect some lockstat and oprofile runs may give
> us opportunities for further optimization.
> 
>        	     	  	  	      - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



