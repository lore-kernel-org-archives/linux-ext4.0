From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] resize2fs: fix ENOSPC corruption case
Date: Mon, 18 May 2009 16:35:13 -0500
Message-ID: <4A11D491.4070809@redhat.com>
References: <4A11D375.30709@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:36293 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbZERVfN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 18 May 2009 17:35:13 -0400
Received: from int-mx2.corp.redhat.com (int-mx2.corp.redhat.com [172.16.27.26])
	by mx2.redhat.com (8.13.8/8.13.8) with ESMTP id n4ILZFsZ030232
	for <linux-ext4@vger.kernel.org>; Mon, 18 May 2009 17:35:15 -0400
Received: from ns3.rdu.redhat.com (ns3.rdu.redhat.com [10.11.255.199])
	by int-mx2.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n4ILZEjo001173
	for <linux-ext4@vger.kernel.org>; Mon, 18 May 2009 17:35:14 -0400
Received: from neon.msp.redhat.com (neon.msp.redhat.com [10.15.80.10])
	by ns3.rdu.redhat.com (8.13.8/8.13.8) with ESMTP id n4ILZD99023956
	for <linux-ext4@vger.kernel.org>; Mon, 18 May 2009 17:35:13 -0400
In-Reply-To: <4A11D375.30709@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Eric Sandeen wrote:
> http://people.redhat.com/esandeen/livecd-creator-imagefile.bz2
> contains an image (for now) which, when resized to 578639, corrupts
> the filesystem.
> 
> This is a bit crazy, I guess, because the fs currently has only
> 1 free block, but still, we should be graceful about the failure.
> Perhaps it would make sense to check the requested valuea against
> the minimum value resize2fs would compute for "-P" and fail (at
> least without a force).

heh, well, maybe not:

[root@inode e2fsprogs]# dumpe2fs -h /mnt/test/livecd-creator-imagefile |
grep "Block count"
dumpe2fs 1.41.5 (23-Apr-2009)
Block count:              578640
[root@inode e2fsprogs]# resize/resize2fs.static -P
/mnt/test/livecd-creator-imagefile
resize2fs 1.41.5 (23-Apr-2009)
Estimated minimum size of the filesystem: 9171138

The estimated minimum size is 16x the current size.

So much for that plan, at least without a bit more work.

-Eric
