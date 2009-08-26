From: Andreas Dilger <adilger@sun.com>
Subject: Re: Enable asynchronous commits by default patch revoked?
Date: Wed, 26 Aug 2009 03:50:35 -0600
Message-ID: <20090826095035.GH5931@webber.adilger.int>
References: <20090824201027.GC17684@mit.edu> <4A92F7E0.9010001@redhat.com>
 <20090824220738.GG17684@mit.edu> <4A93103B.2000909@redhat.com>
 <20090824232804.GJ17684@mit.edu> <20090824234336.GU5931@webber.adilger.int>
 <20090825001554.GN17684@mit.edu> <20090825175247.GX5931@webber.adilger.int>
 <4A94287C.9060509@redhat.com> <20090825211132.GV17684@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Ric Wheeler <rwheeler@redhat.com>,
	Christian Fischer <Christian.Fischer@easterngraphics.com>,
	linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:65376 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756664AbZHZJuh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Aug 2009 05:50:37 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n7Q9oVqi008484
	for <linux-ext4@vger.kernel.org>; Wed, 26 Aug 2009 02:50:31 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KOZ007009TBHV00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Wed,
 26 Aug 2009 02:50:30 -0700 (PDT)
In-reply-to: <20090825211132.GV17684@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Aug 25, 2009  17:11 -0400, Theodore Ts'o wrote:
> The problem is without my patch, the barrier=1 mount option is
> completely ignored, and there's no way to enable barriers with
> async_commit --- which is clearly wrong.  So with my patch, it now
> becomes safe for people to experiment with async_commit --- and if
> they also to experiment with the barrier=0 w/ "hdparm -W 0" they can
> do so.  For any given workload and hardware combination, there is
> therefore three safe configuarions that people can try benchmarking:
> 
>      !async_commit,barrier=1,"hdparm -W 1"	(currently the default)
>      async_commit,barrier=1,"hdparm -W 1"
>      async_commit,barrier=0,"hdparm -W 0"
> 
> (n.b., !async_commit,barrier=0,"hdparm -W 0" is not completely safe,
> since without the barrier, it's possible, although granted not very
> likely, for the block layer elevator algorithm to reorder blocks in
> block device queue.)

I'm not sure I understand about the "n.b." case.  If the filesystem
is running with !async_commit,barrier=0,wcache=0 (which is basically
ext3 with write cache off), it should still have the jbd code doing
an explicit wait for the data blocks (which should be guaranteed to
make it to disk, wcache being off) before even submitting the commit
block to the elevator?  It doesn't matter what order the transaction
blocks are written to disk, so long as the commit block is last.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

