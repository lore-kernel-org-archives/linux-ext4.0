From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH, RFC V3] ext4: limit block allocations for	indirect-block
 files to < 2^32
Date: Thu, 10 Sep 2009 23:10:06 +0200
Message-ID: <20090910211006.GF9372@webber.adilger.int>
References: <4AA1920C.9040406@redhat.com> <4AA1D94F.8060703@redhat.com>
 <20090905164535.GL4197@webber.adilger.int> <4AA92307.4010304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:39128 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbZIJVKL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Sep 2009 17:10:11 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n8ALAASx004170
	for <linux-ext4@vger.kernel.org>; Thu, 10 Sep 2009 14:10:10 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.04 64bit (built Jul  2 2009))
 id <0KPR00M00X63HZ00@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Thu,
 10 Sep 2009 14:10:10 -0700 (PDT)
In-reply-to: <4AA92307.4010304@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sep 10, 2009  11:02 -0500, Eric Sandeen wrote:
> This patch limits such allocations to < 232, and adds
> WARN_ONs (maybe should be BUG_ONs) if we do get blocks
> larger than that.

Given that this may corrupt the filesystem (e.g. block
2^32 turning into block 0 and overwriting the superblock)
I think a BUG_ON() is probably more appropriate.  This
should only happen with software bugs, so it is more
appropriate than ext4_error() I think.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

