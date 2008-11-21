From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH -V2 4/5] ext4: Use both hi and lo bits of the group
	desc values.
Date: Fri, 21 Nov 2008 23:11:10 +0530
Message-ID: <20081121174110.GH11212@skywalker>
References: <1227285875-18011-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1227285875-18011-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4926F00D.6030403@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, tytso@mit.edu, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>, Coly Li <coyli@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:34321 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876AbYKURnx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 21 Nov 2008 12:43:53 -0500
Received: from sd0109e.au.ibm.com (d23rh905.au.ibm.com [202.81.18.225])
	by e23smtp02.au.ibm.com (8.13.1/8.13.1) with ESMTP id mALHh3kk001176
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 04:43:03 +1100
Received: from d23av01.au.ibm.com (d23av01.au.ibm.com [9.190.234.96])
	by sd0109e.au.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id mALHfL3J045062
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 04:41:21 +1100
Received: from d23av01.au.ibm.com (loopback [127.0.0.1])
	by d23av01.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id mALHfLYd012910
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 04:41:21 +1100
Content-Disposition: inline
In-Reply-To: <4926F00D.6030403@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 21, 2008 at 11:29:49AM -0600, Eric Sandeen wrote:
> Aneesh Kumar K.V wrote:
> > Rename the lower bits with suffix _lo and add helper
> > to access the values. Also rename bg_itable_unused_hi
> > to bg_pad as in e2fsprogs. bg_itable_unused_hi is never
> > used before
> 
> Maybe you can add info about under which circumstances (what sort of
> fielsystem geometry) the hi bits are needed?  And the failure mode when
> we don't use them, if that's known?

Coly actually said it was added for inode reservation. But he agreed to
drop the high bits now and add them later once the performance issue
with the patch is addressed.

-aneesh
