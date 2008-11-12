From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC,PATCH] 64-bit support for e2fsprogs
Date: Wed, 12 Nov 2008 13:25:38 -0700
Message-ID: <20081112202538.GN16005@webber.adilger.int>
References: <1226461390-5502-1-git-send-email-vaurora@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org,
	Valerie Aurora Henson <vaurora@redhat.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:36210 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303AbYKLU0B (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 12 Nov 2008 15:26:01 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mACKPj7b004160
	for <linux-ext4@vger.kernel.org>; Wed, 12 Nov 2008 12:25:55 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KA800801LTVQQ00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 12 Nov 2008 12:25:45 -0800 (PST)
In-reply-to: <1226461390-5502-1-git-send-email-vaurora@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Nov 11, 2008  19:42 -0800, Valerie Aurora Henson wrote:
> Use the following mke2fs command to produce a file system with more
> than 2^32 blocks:
> 
> $ mke2fs -t ext4 -O 64bit -b 4096 -N 200000 <device>

Ted, this actually exposes a bug in mke2fs, in that the device size to
"type" detection code is broken.  Val was reporting that running on a
16TB device would pick the "floppy" type and try to use 1024-byte blocks
and 1 inode per 1024 bytes, which would exceed the 2^32 inode limit.
Hence the current requirement to specify a 4096-byte blocksize and a
hard limit on the number of inodes.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

