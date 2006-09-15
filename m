From: Andrew Morton <akpm@osdl.org>
Subject: Re: ext3 sequential read performance (~20%) degrade
Date: Thu, 14 Sep 2006 17:03:08 -0700
Message-ID: <20060914170308.9595141c.akpm@osdl.org>
References: <1158276972.24991.10.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: sct@redhat.com, ext4 <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:10647 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932158AbWIOADT (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Sep 2006 20:03:19 -0400
To: Badari Pulavarty <pbadari@us.ibm.com>
In-Reply-To: <1158276972.24991.10.camel@dyn9047017100.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 14 Sep 2006 16:36:12 -0700
Badari Pulavarty <pbadari@us.ibm.com> wrote:

> Hi Andrew,
> 
> I have been working on tracking down ~20% performance degrade for
> sequential read performance for ext3. 

oop.  I'd kinda prefer that we discover things like this before the patch
gets into mainline.

> Finally narrowed it down to get_blocks() support. If I force
> ext3_get_blocks_handle() to always return 1 block - I get better
> IO rate. I did all the usual stuff, tracked down requests, traced
> blocksizes, looked at readahead code, looked at mpage_readpages()
> etc.. I still can't figure out how to explain the degrade..
> 
> Any suggestions on how to track it down.

Learn to driver Jens's blktrace stuff, find out why the IO scheduling went
bad.

Number one suspicion: the buffer_boundary() stuff isn't working.

> Thanks,
> Badari
> 
> # cat iotest
> mount /dev/sdb2 /mnt/tmp
> time dd if=/mnt/tmp/testfile of=/dev/null bs=4k count=1048576
> umount /mnt/tmp

Try using /proc/sys/vm/drop_caches, or ext3-tools's fadvise.c...

> 2.6.18-rc6: (multiblock):
> 
> # ./iotest
> 1048576+0 records in
> 1048576+0 records out
> 4294967296 bytes (4.3 GB) copied, 75.2654 seconds, 57.1 MB/s
> 
> real    1m15.282s
> user    0m0.248s
> sys     0m4.292s
> 
> 2.6.18-rc6 (force single block in ext3_get_blocks_handle():
> 
> # ./iotest
> ./iotest
> 1048576+0 records in
> 1048576+0 records out
> 4294967296 bytes (4.3 GB) copied, 62.9472 seconds, 68.2 MB/s
> 
> real    1m2.976s
> user    0m0.268s
> sys     0m4.280s

ow.
