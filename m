From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4_fallocate
Date: Thu, 28 Jun 2012 08:48:34 -0400
Message-ID: <20120628124834.GA5313@thunk.org>
References: <4FE8086F.4070506@zoho.com>
 <20120625085159.GA18931@gmail.com>
 <20120625191744.GB9688@thunk.org>
 <4FE9B57F.4030704@redhat.com>
 <4FE9F9F4.7010804@zoho.com>
 <4FEA0DD1.8080403@gmail.com>
 <4FEA1415.8040809@redhat.com>
 <4FEA1F18.6010206@redhat.com>
 <20120627193034.GA3198@thunk.org>
 <4FEB9115.6090309@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <ricwheeler@gmail.com>, Fredrick <fjohnber@zoho.com>,
	Ric Wheeler <rwheeler@redhat.com>, linux-ext4@vger.kernel.org,
	Andreas Dilger <adilger@dilger.ca>, wenqing.lz@taobao.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:53262 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab2F1Msp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Jun 2012 08:48:45 -0400
Content-Disposition: inline
In-Reply-To: <4FEB9115.6090309@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 27, 2012 at 07:02:45PM -0400, Eric Sandeen wrote:
> 
> fallocate 1g, do 16m of 4k random IOs, sync after each:
> 
> # for I in a b c; do rm -f testfile; echo 3 > /proc/sys/vm/drop_caches; fio tytso.fio | grep 2>&1 WRITE; done
> 
>   WRITE: io=16384KB, aggrb=154KB/s, minb=158KB/s, maxb=158KB/s, mint=105989msec, maxt=105989msec
>   WRITE: io=16384KB, aggrb=163KB/s, minb=167KB/s, maxb=167KB/s, mint=99906msec, maxt=99906msec
>   WRITE: io=16384KB, aggrb=176KB/s, minb=180KB/s, maxb=180KB/s, mint=92791msec, maxt=92791msec
> 
> same, but overwrite pre-written 1g file (same as the expose-my-data option ;)
> 
> # dd if=/dev/zero of=testfile bs=1M count=1024
> # for I in a b c; do echo 3 > /proc/sys/vm/drop_caches; fio tytso.fio | grep 2>&1 WRITE; done
> 
>   WRITE: io=16384KB, aggrb=164KB/s, minb=168KB/s, maxb=168KB/s, mint=99515msec, maxt=99515msec
>   WRITE: io=16384KB, aggrb=164KB/s, minb=168KB/s, maxb=168KB/s, mint=99371msec, maxt=99371msec
>   WRITE: io=16384KB, aggrb=164KB/s, minb=168KB/s, maxb=168KB/s, mint=99677msec, maxt=99677msec
> 

There's a pretty large range comparing the first set versus the second
set of numbers.  With the second set of numbers, the times are much
more stable.

I wonder if one of the things that's going on is file placement; if
you're constantly deleting and recreating the file, are we getting the
same block numbers or not?  (And if we're not, is that something we
need to look at vis-a-vis the block allocator --- especially with
SSD's?)

						- Ted
