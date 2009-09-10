From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC V3] ext4: limit block allocations for	indirect-block
 files to < 2^32
Date: Fri, 11 Sep 2009 00:01:00 +0200
Message-ID: <20090910220100.GK9372@webber.adilger.int>
References: <4AA1920C.9040406@redhat.com> <4AA1D94F.8060703@redhat.com>
 <20090905164535.GL4197@webber.adilger.int> <4AA92307.4010304@redhat.com>
 <20090910211006.GF9372@webber.adilger.int> <4AA96CB0.3090309@redhat.com>
 <20090910215158.GI9372@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:41878 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150AbZIJWBB (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Sep 2009 18:01:01 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8AM14Dj009631
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 15:01:04 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KPR00G00ZHSKY00@fe-sfbay-10.sun.com> for linux-ext4@vger.kernel.org; Thu,
 10 Sep 2009 15:01:04 -0700 (PDT)
In-reply-to: <20090910215158.GI9372@webber.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 10, 2009  23:51 +0200, Andreas Dilger wrote:
> Well, it may depend a lot on which inodes are in use.  That will set the
> goal block, and may prevent any above-16TB allocations.  Either you could
> fill the bitmaps with 0xff (and zero the free blocks counters, to avoid
> problems with mballoc), or actually fill the first 16TB of the filesystem.

Or, just start creating top-level directories until you get one past
16TB and use that for your test...  We have a patch for allowing a
goal inode to be specified, and it might make sense to add a mount
option to allow setting the inode goal for testing...

Hey, look, I even posted that patch, I now recall:
http://osdir.com/ml/linux-ext4/2009-06/msg00233.html

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

