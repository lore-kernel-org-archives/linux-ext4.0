From: Andreas Dilger <adilger@sun.com>
Subject: Re: Ext4 without a journal: some benchmark results
Date: Thu, 08 Jan 2009 06:03:57 -0700
Message-ID: <20090108130357.GW13721@webber.adilger.int>
References: <6601abe90901071129v3de159d4jcf3b250aac40d0eb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:54529 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754494AbZAHNEB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 8 Jan 2009 08:04:01 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n08D40pZ003755
	for <linux-ext4@vger.kernel.org>; Thu, 8 Jan 2009 05:04:00 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KD500001LM7N200@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 08 Jan 2009 05:04:00 -0800 (PST)
In-reply-to: <6601abe90901071129v3de159d4jcf3b250aac40d0eb@mail.gmail.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jan 07, 2009  11:29 -0800, Curt Wohlgemuth wrote:
> Iozone was run with the following command line:
> 
>       iozone -t (# threads) -s 2g -r 256k -I -T -i0 -i1 -i2
> 
> I.e., throughput mode; 2GiB file; 256KiB buffer; O_DIRECT.  Tests were
> limited to

How much RAM is on the test system?  If the file size is only 2GB then
it will likely fit into RAM, which is possibly why the performance
numbers of all the filesystems is so close together.  The other possibility
is that a single disk is the performance bottleneck and all of the
filesystems can feed a single disk at a reasonable rate.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

