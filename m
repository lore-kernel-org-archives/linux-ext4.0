From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH e2fsprogs] fix test in ext2fs_check_desc() for inode table
 within block group
Date: Fri, 20 Jul 2007 17:04:32 -0500
Message-ID: <46A13170.5020205@redhat.com>
References: <46A12E22.3030102@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:34610 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758649AbXGTWKQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 20 Jul 2007 18:10:16 -0400
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.13.1/8.13.1) with ESMTP id l6KMAFrt004399
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 18:10:15 -0400
Received: from lacrosse.corp.redhat.com (lacrosse.corp.redhat.com [172.16.52.154])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id l6KMAFcI017294
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 18:10:15 -0400
Received: from [10.15.80.10] (neon.msp.redhat.com [10.15.80.10])
	by lacrosse.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id l6KMAEt9020789
	for <linux-ext4@vger.kernel.org>; Fri, 20 Jul 2007 18:10:15 -0400
In-Reply-To: <46A12E22.3030102@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Eric Sandeen wrote:
> The test in ext2fs_check_desc() is off by one; if the inode table
> goes all the way to the last block of the block group, it will 
> falsely assert that it has extended past it.  The last block
> of a range is start + len -1, not start + len.
> 
(btw the kernel has this same problem, so it's not mountable either -
will send that patch Monday)

-Eric
