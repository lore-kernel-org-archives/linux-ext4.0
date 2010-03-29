From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: 2.6.33.1: ext4 disk free weirdness
Date: Mon, 29 Mar 2010 09:48:50 -0500
Message-ID: <4BB0BDD2.3080100@redhat.com>
References: <20100329045748.GR2657@zip.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: CaT <cat@zip.com.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777Ab0C2Osz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 29 Mar 2010 10:48:55 -0400
In-Reply-To: <20100329045748.GR2657@zip.com.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

CaT wrote:
> Using kernel 2.6.33.1. Am rsyncing from /data/mirror (a raid0 mount) to
> /dev/sda1 (a usb HD). Both filesystems formatted as ext3 but mounted as
> ext4. /mnt filesystem is only being added to and currently large files
> (iso files 700MB-4.4GB) are being copied. When I remounted /mnt as ext3
> I could not duplicate the issue and the amount of disk used stabilised
> at 182G. The df results, whilst /mnt is mounted as ext4, are below:

I would say this is likely speculative allocation due to delalloc
(ext4 has to reserve worst-case metadata amounts to prepare for
delalloc writeback).  When the file data actually gets written out,
the worst-case reservation is freed up again.  We also flush and
switch to nodelalloc when the filesystem is pretty close to full.
see ext4_nonda_switch() for example.

This looks pretty severe though, more than I would expect
from that behavior.

Some interesting tests would be to try it again -o nodelalloc
(I expect the behavior to go away) and maybe to copy a single
large file and see how bad the overshoot is before and after
a "sync".

-Eric


> 1 [29/03 15:05:58] >> df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md5              1.3T  1.2T  113G  92% /data/mirror
> /dev/sda1             917G  317G  555G  37% /mnt
> 1 [29/03 15:11:05] >> df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md5              1.3T  1.2T  113G  92% /data/mirror
> /dev/sda1             917G  224G  647G  26% /mnt
> 1 [29/03 15:41:38] >> df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md5              1.3T  1.2T  113G  92% /data/mirror
> /dev/sda1             917G  670G  201G  77% /mnt 
> 1 [29/03 15:48:32] >> df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md5              1.3T  1.2T  113G  92% /data/mirror
> /dev/sda1             917G  246G  626G  29% /mnt 
> 1 [29/03 15:48:36] >> df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md5              1.3T  1.2T  113G  92% /data/mirror
> /dev/sda1             917G  313G  559G  36% /mnt 
> 1 [29/03 15:48:37] >> df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md5              1.3T  1.2T  113G  92% /data/mirror
> /dev/sda1             917G  396G  475G  46% /mnt 
> 1 [29/03 15:48:37] >> df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md5              1.3T  1.2T  113G  92% /data/mirror
> /dev/sda1             917G  615G  256G  71% /mnt 
> 1 [29/03 15:48:39] >> df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md5              1.3T  1.2T  113G  92% /data/mirror
> /dev/sda1             917G  671G  201G  77% /mnt 
> 1 [29/03 15:48:40] >> df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md5              1.3T  1.2T  113G  92% /data/mirror
> /dev/sda1             917G  671G  201G  77% /mnt 
> 1 [29/03 15:48:40] >> df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md5              1.3T  1.2T  113G  92% /data/mirror
> /dev/sda1             917G  215G  656G  25% /mnt 
> 1 [29/03 15:48:41] >> df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md5              1.3T  1.2T  113G  92% /data/mirror
> /dev/sda1             917G  334G  538G  39% /mnt 
> 1 [29/03 15:48:42] >> df -h
> Filesystem            Size  Used Avail Use% Mounted on
> /dev/md5              1.3T  1.2T  113G  92% /data/mirror
> /dev/sda1             917G  522G  349G  60% /mnt 
> 1 [29/03 15:48:43] >> 
> 

