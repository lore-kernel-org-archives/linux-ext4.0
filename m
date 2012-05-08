From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: ext4, barrier, md/RAID1 and write cache
Date: Tue, 8 May 2012 11:02:19 -0600
Message-ID: <3FF04DCD-7CE4-486A-92F5-2337BC64AE50@dilger.ca>
References: <4FA7A83E.6010801@pocock.com.au> <201205080024.54183.Martin@lichtvoll.de> <4FA85960.6040703@pocock.com.au> <201205081655.38146.ms@teamix.de> <4FA93BB2.9050509@pocock.com.au>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Martin Steigerwald <ms@teamix.de>,
	Martin Steigerwald <Martin@lichtvoll.de>,
	linux-ext4@vger.kernel.org
To: Daniel Pocock <daniel@pocock.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:23317 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772Ab2EHRCW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 May 2012 13:02:22 -0400
In-Reply-To: <4FA93BB2.9050509@pocock.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2012-05-08, at 9:28 AM, Daniel Pocock wrote:
> My impression is that the faster performance of the USB disk was a red
> herring, and the problem really is just the nature of the NFS protocol
> and the way it is stricter about server-side caching (when sync is
> enabled) and consequently it needs more iops.
> 
> I've turned two more machines (a HP Z800 with SATA disk and a Lenovo
> X220 with SSD disk) into NFSv3 servers, repeated the same tests, and
> found similar performance on the Z800, but 20x faster on the SSD (which
> can support more IOPS)

Another possible option is to try "-o data=journal" for the ext4
filesystem.  This will, in theory, turn your random IO workload to
the filesystem into a streaming IO workload to the journal.  This
is only useful if the filesystem is not continually busy, and needs
a large enough journal (and enough RAM to match) to handle the burst
IO loads.

For example, if you are writing 1GB of data you need a 4GB journal
size and 4GB of RAM to allow all of the data to burst into the journal
and write into the filesystem asynchronously.  It it would also be
interesting to see if there is a benefit from running with an external
journal (possibly on a separate disk or an SSD), because then the
synchronous part of the IO does not seek, and then the small IOs can
be safely written to the filesystem asynchronously (they will be
rewritten from the journal if the server crashes).

Typically, data=journal mode will decrease I/O performance by 1/2,
since all data is written twice, but in your case NFS is hurting the
performance far more than this, so the extra "overhead" may still
give better performance visible to the clients.

>>> All the iostat output is typically like this:
>>> Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s
>>> avgrq-sz avgqu-sz   await  svctm  %util
>>> dm-23             0.00     0.00    0.20  187.60     0.00     0.81
>>> 8.89     2.02   10.79   5.07  95.20
>>> dm-23             0.00     0.00    0.20  189.80     0.00     0.91
>>> 9.84     1.95   10.29   4.97  94.48
>>> dm-23             0.00     0.00    0.20  228.60     0.00     1.00
>>> 8.92     1.97    8.58   4.10  93.92
>>> dm-23             0.00     0.00    0.20  231.80     0.00     0.98
>>> 8.70     1.96    8.49   4.06  94.16
>>> dm-23             0.00     0.00    0.20  229.20     0.00     0.94
>>> 8.40     1.92    8.39   4.10  94.08
>> 
>> Hmmm, disk looks quite utilitzed. Are there other I/O workloads on the 
>> machine?
> 
> No, just me testing it

Looking at these results, the average IO size is very small.  Looking
at the writes/second of around 210w/s and the write bandwidth of 1MB/s,
this is only an average write size of only 4.5kB.

Cheers, Andreas





