From: Andreas Dilger <adilger@sun.com>
Subject: Re: Segmentation fault in e4defrag -c
Date: Mon, 29 Jun 2009 23:49:59 +0200
Message-ID: <20090629214959.GT3570@webber.adilger.int>
References: <20090625105558.GA21773@uio.no> <4A4487B0.9080000@sx.jp.nec.com>
 <20090626093816.GA3175@uio.no> <4A485929.7010403@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Steinar H. Gunderson" <sgunderson@bigfoot.com>,
	Kazuya Mio <k-mio@sx.jp.nec.com>, linux-ext4@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:57166 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbZF2VuR (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 29 Jun 2009 17:50:17 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n5TLo5Rq028350
	for <linux-ext4@vger.kernel.org>; Mon, 29 Jun 2009 14:50:18 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KM000000S6YZX00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 29 Jun 2009 14:50:05 -0700 (PDT)
In-reply-to: <4A485929.7010403@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 29, 2009  15:03 +0900, Akira Fujita wrote:
> >   Size: 4050385   	Blocks: 0          IO Block: 4096   regular file
> > Device: fd12h/64786d	Inode: 688755      Links: 1
> > Access: (0644/-rw-r--r--)  Uid: ( 1000/   sesse)   Gid: ( 1000/   sesse)
> > Access: 2009-05-30 03:08:38.724454316 +0200
> > Modify: 2008-09-01 20:38:26.135589449 +0200
> > Change: 2008-09-01 20:38:26.135589449 +0200
> 
> File size is "4050385" but Blocks is "0"
> probably means blocks are not allocated yet or file is *corrupted*.
> Is your mp3 file available?

Well, this is a sparse file for some reason (e.g. failed mp3 p2p download).

> Anyway, with this patch, 0 blocks file is skipped,
> therefore the segmentation fault you had will not happen.

Is it possible that the code has not been tested with sparse files?
In that case, the check for size == 0 is only going to catch a single
case of problem, and not handle general sparse files.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

