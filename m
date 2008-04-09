From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Problem with fsstress on powerpc
Date: Wed, 9 Apr 2008 13:51:15 +0530
Message-ID: <20080409082115.GA8238@skywalker>
References: <20080408152455.GA10827@skywalker> <20080409074457.GB944@dmon-lap.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Sandeen <sandeen@redhat.com>, Mingming Cao <cmm@us.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Dmitri Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:40140 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbYDIIVb (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Apr 2008 04:21:31 -0400
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id m398LWq3017611
	for <linux-ext4@vger.kernel.org>; Wed, 9 Apr 2008 18:21:32 +1000
Received: from d23av03.au.ibm.com (d23av03.au.ibm.com [9.190.234.97])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m398PKCJ276874
	for <linux-ext4@vger.kernel.org>; Wed, 9 Apr 2008 18:25:20 +1000
Received: from d23av03.au.ibm.com (loopback [127.0.0.1])
	by d23av03.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m398LZZa022369
	for <linux-ext4@vger.kernel.org>; Wed, 9 Apr 2008 18:21:36 +1000
Content-Disposition: inline
In-Reply-To: <20080409074457.GB944@dmon-lap.sw.ru>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 09, 2008 at 11:44:57AM +0400, Dmitri Monakhov wrote:
> On 20:54 Tue 08 Apr     , Aneesh Kumar K.V wrote:
> > Hi All,
> > 
> > Test case: fsstress with fallocate test case added.
> This may happens because of direct write.
> Please add  exact fsstess command and options.
> > 

fsstress -c -n1000 -p1000  -d /mnt/tmp/

What i found was also related. The file which had errors had the below
operations on them.

82/901: dread d16/d20/d22/d2d/d63/d68/d9a/f93 [622592,53248] 0
82/939: dwrite d16/d20/d22/d2d/d63/d68/d9a/f93 [1093632,77824] 28


9/863: fallocate d1/d2d/d32/d8f/d97/d108/d9b/ffb [2041,75851] 28


18/733: fallocate d9/ddd/f86 [481025,18486] 0
18/735: dwrite d9/ddd/f86 [679936,36864] 0
18/764: dread d9/ddd/f86 [53248,8192] 0
18/910: dwrite d9/ddd/f86 [1454080,4096] 28
18/999: dwrite d9/ddd/f86 [1798144,61440] 28


But what would happen during direct write that cause this ?

-aneesh
