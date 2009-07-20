From: Andreas Dilger <adilger@sun.com>
Subject: Re: file allocation problem
Date: Mon, 20 Jul 2009 15:18:31 -0600
Message-ID: <20090720211831.GV4231@webber.adilger.int>
References: <200907161331.17623.coolo@suse.de>
 <200907170717.12225.coolo@suse.de> <20090717142628.GL8508@mit.edu>
 <200907172002.19286.coolo@suse.de> <20090717211444.GF4231@webber.adilger.int>
 <4A63A1F1.9040703@cox.net>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Ron Johnson <ron.l.johnson@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:54250 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107AbZGTVTA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jul 2009 17:19:00 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6KLIvZT000506
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2009 14:18:58 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KN300A00MDLP500@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Mon,
 20 Jul 2009 14:18:57 -0700 (PDT)
In-reply-to: <4A63A1F1.9040703@cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 19, 2009  17:45 -0500, Ron Johnson wrote:
> On 2009-07-17 16:14, Andreas Dilger wrote:
>> Well, this isn't quite correct.  The mballoc code only tries to allocate
>> "large" files on power-of-two boundaries, where large is 64kB by default,
>> but is tunable in /proc.  For smaller files it tries to pack them together
>> into the same block, or into gaps that are exactly the size of the file.
>
> How does ext4 act on growing files?  I.e., creating a tarball that,  
> obviously, starts at 0 bytes and then grows to multi-GB?

ext4 has "delayed allocation" (delalloc) so that no blocks are allocated
during initial file writes, but rather only when RAM is running short or
when the data has been sitting around for a while.

Normally, if you are writing to a file with _most_ applications the IO
rate is high enough that within the 5-30s memory flush interval the
size of the file has grown large enough to give the allocator an idea
whether the file will be small or large.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

