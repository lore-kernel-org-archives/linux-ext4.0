From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext4: odd values for mkfs.ext4 -i
Date: Tue, 03 Mar 2009 17:11:00 -0700
Message-ID: <20090304001100.GV3199@webber.adilger.int>
References: <alpine.LSU.2.00.0903040001120.12969@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:62569 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbZCDALc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Mar 2009 19:11:32 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n240BGtk017702
	for <linux-ext4@vger.kernel.org>; Tue, 3 Mar 2009 16:11:28 -0800 (PST)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7.0-3.01 64bit (built Dec 23 2008))
 id <0KFY00M00G013Q00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Tue,
 03 Mar 2009 16:11:16 -0800 (PST)
In-reply-to: <alpine.LSU.2.00.0903040001120.12969@fbirervta.pbzchgretzou.qr>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mar 04, 2009  00:07 +0100, Jan Engelhardt wrote:
> Is it ok that e2fsprogs-1.41.4 allows odd values for -i, such as
> in `mkfs.ext4 -i 2047`? If inodes were arranged every 2047 bytes, they 
> would not be aligned, which would mean one extra sector would have to be 
> read every now and then, does not it?  Should odd values be rejected?

Note that the "-i" value is a ratio between the total space in the filesystem
and the number of inodes.  It does not dictate how those inodes are layed
out on disk.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

