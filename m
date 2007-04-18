From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Performance degradation with FFSB between 2.6.20 and 2.6.21-rc7
Date: Wed, 18 Apr 2007 13:57:09 -0700
Message-ID: <20070418135709.b499e050.akpm@linux-foundation.org>
References: <462622F8.10107@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46219 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888AbXDRU5X (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 18 Apr 2007 16:57:23 -0400
In-Reply-To: <462622F8.10107@bull.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

> On Wed, 18 Apr 2007 15:54:00 +0200 Valerie Clement <valerie.clement@bull.net> wrote:
> 
> Running benchmark tests (FFSB) on an ext4 filesystem, I noticed a 
> performance degradation (about 15-20 percent) in sequential write tests 
> between 2.6.19-rc6 and 2.6.21-rc4 kernels.
> 
> I ran the same tests on ext3 and XFS filesystems and I saw the same 
> performance difference between the two kernel versions for these two 
> filesystems.
> 
> I have also reproduced it between 2.6.20.7 and 2.6.21-rc7.
> The FFSB tests run 16 threads, each creating 1GB files. The tests were 
> done on the same x86_64 system, with the same kernel configuration and 
> on the same scsi device. Below are the throughput values given by FFSB.
> 
>    kernel           XFS                ext3
> ----------
>   2.6.20.7        48 MB/sec         44 MB/sec
> 
>   2.6.21-rc7      38 MB/sec         37 MB/sec
> 
> Did anyone else run across the problem?
> Is there a known issue?
> 

That's a new discovery, thanks.

It could be due to I/O scheduler changes.  Which one are you using?  CFQ?

Or it could be that there has been some changed behaviour at the VFS/pagecache
layer: the VFS might be submitting little hunks of lots of files, rather than
large hunks of few files.

Or it could be a block-layer thing: perhaps some driver change has caused
us to be placing less data into the queue.  Which device driver is that machine
using?

Being a simple soul, the first thing I'll try when I get near a test box
will be

for i in $(seq 1 16)
do
	time dd if=/dev/zero of=$i bs=1M count=1024 &
done
