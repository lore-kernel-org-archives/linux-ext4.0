From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: Performance degradation with FFSB between 2.6.20 and 2.6.21-rc7
Date: Thu, 19 Apr 2007 11:03:47 +0200
Message-ID: <20070419090346.GE20928@kernel.dk>
References: <462622F8.10107@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Valerie Clement <valerie.clement@bull.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S2993217AbXDSJGR@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <462622F8.10107@bull.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Apr 18 2007, Valerie Clement wrote:
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
>   kernel           XFS                ext3
> ----------
>  2.6.20.7        48 MB/sec         44 MB/sec
> 
>  2.6.21-rc7      38 MB/sec         37 MB/sec
> 
> Did anyone else run across the problem?
> Is there a known issue?

Please tell me how you are running ffsb, and also please include a
dmessg from a booted system.

-- 
Jens Axboe
