From: Alex Zhuravlev <Alex.Zhuravlev@Sun.COM>
Subject: Re: [PATCH -V2 3/5] ext4: Fix the race between read_block_bitmap and
 mark_diskspace_used
Date: Mon, 24 Nov 2008 10:14:27 +0300
Message-ID: <492A5453.9030801@sun.com>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20081123140038.GC26473@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:64422 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbYKXGPV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 24 Nov 2008 01:15:21 -0500
Received: from fe-emea-10.sun.com (gmp-eb-lb-1-fe3.eu.sun.com [192.18.6.10])
	by gmp-eb-inf-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAO6FFWg005932
	for <linux-ext4@vger.kernel.org>; Mon, 24 Nov 2008 06:15:19 GMT
Received: from conversion-daemon.fe-emea-10.sun.com by fe-emea-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAT00G01QLFFC00@fe-emea-10.sun.com>
 (original mail from Alex.Zhuravlev@Sun.COM) for linux-ext4@vger.kernel.org;
 Mon, 24 Nov 2008 06:15:15 +0000 (GMT)
In-reply-to: <20081123140038.GC26473@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Tso wrote:
> My bigger concern is given that we are playing games like *this*:
> 
> 		if ((cur & 31) == 0 && (len - cur) >= 32) {
> 			/* fast path: set whole word at once */
> 			addr = bm + (cur >> 3);
> 			*addr = 0xffffffff;
> 			cur += 32;
> 			continue;
> 		}

this is to avoid expensive LOCK prefix in some cases.

> without taking a lock, I'm a little surprised we haven't been
> seriously burned by other race conditions.  What's the point of
> calling mb_set_bit_atomic() and passing in a spinlock if we are doing
> this kind of check without the protection of the same spinlock?!?

why would we need a lock for a whole word bitop ?

thanks, Alex

