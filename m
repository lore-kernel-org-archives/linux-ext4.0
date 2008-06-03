From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Questions for article
Date: Tue, 03 Jun 2008 11:49:54 -0400
Message-ID: <yq1zlq2o6vx.fsf@sermon.lab.mkp.net>
References: <27337.143.166.226.57.1212443437.squirrel@tomslinux.homelinux.org>
	<20080602225942.GQ2961@webber.adilger.int>
	<61365.143.166.255.40.1212505833.squirrel@tomslinux.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Thomas King <kingttx@tomslinux.homelinux.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:39325 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbYFCPvq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 Jun 2008 11:51:46 -0400
In-Reply-To: <61365.143.166.255.40.1212505833.squirrel@tomslinux.homelinux.org> (Thomas King's message of "Tue\, 3 Jun 2008 10\:10\:33 -0500 \(CDT\)")
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>>>>> "Thomas" == Thomas King <kingttx@tomslinux.homelinux.org> writes:

Thomas> - T10 DIF (block protect?) aware file system

I'm not really sure what the ext4 people are officially planning but I
know from conversations with Ted and a few others that there's
interest.  Wiring up ext4 to the block integrity infrastructure is
pretty easy.  It's defining the tagging and making fsck use it that's
the hard part.  Some of that hinges on a userland interface that I
haven't quite finished baking yet.

However, a filesystem doesn't have to be explicitly DIF-aware to take
advantage of it.  Sector tagging is just icing on the cake.  The
current DIF infrastructure automagically protects all I/O that doesn't
already have integrity metadata attached.

Unfortunately, ext[23] aren't working well with protection turned on
right now.  The way DIF works is that you add a checksum to the I/O
when it is submitted.  If there's a mismatch, the HBA or the drive
will reject the I/O.  And unfortunately both ext2 and ext3 frequently
modify pages that are in flight, causing a checksum mismatch.  I have
yet to try ext4.

XFS and btrfs work fine with DIF except for the generic writable mmap
hole that I think I'm about to fix.

-- 
Martin K. Petersen	Oracle Linux Engineering

