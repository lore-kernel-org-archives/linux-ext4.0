From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC 0/2] ext4: zero uninitialized inode tables
Date: Tue, 25 Nov 2008 14:10:43 -0700
Message-ID: <20081125211043.GT3186@webber.adilger.int>
References: <20081121102309.182113793@bull.net>
 <20081125053226.GE20928@mit.edu>
 <18731.61311.620237.554814@frecb006361.adech.frec.bull.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@MIT.EDU>, linux-ext4@vger.kernel.org
To: Solofo.Ramangalahy@bull.net
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:42083 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbYKYVLA (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Nov 2008 16:11:00 -0500
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAPLAqqE000764
	for <linux-ext4@vger.kernel.org>; Tue, 25 Nov 2008 13:10:52 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAW00G01QHQFT00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 25 Nov 2008 13:10:52 -0800 (PST)
In-reply-to: <18731.61311.620237.554814@frecb006361.adech.frec.bull.fr>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 25, 2008  13:28 +0100, Solofo.Ramangalahy@bull.net wrote:
> Appart from the data structures change you mentionned, these changes
> were discussed:
> . a mount option to disable the threads when doing testing/performance
>   benchmarking

Sure.

> . a flag in s_flags field of struct ext4_super_block to indicate that
>   the zeroing has been done on all the groups. Possibly reset with
>   resize.

I was thinking that it makes sense to have this same thread do checking
of all the block group metadata as it traverses the filesystem.  That
includes validating the GDT checksums, checking the existing block and
inode bitmaps (and possibly checksums for them, when that is implemented),
along with zeroing the inode table.

The only requirement is that there only be a single such thread running
on the filesystem at one time, and that if the filesystem is unmounted
that the thread be killed before the unmount is completed.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

