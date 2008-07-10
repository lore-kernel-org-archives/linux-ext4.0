From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: Segfaults--they're back!
Date: Thu, 10 Jul 2008 10:51:50 +0530
Message-ID: <20080710052150.GC6764@skywalker>
References: <3.0.6.32.20080709150004.01bd9858@pop.west.cox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Theodore Tso <tytso@mit.edu>, Mingming <cmm@us.ibm.com>
To: Gary Hawco <ghawco@cox.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:32851 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbYGJFWE (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2008 01:22:04 -0400
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp05.au.ibm.com (8.13.1/8.13.1) with ESMTP id m6A5LK3W017878
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2008 15:21:20 +1000
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6A5LYEv3137590
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2008 15:21:34 +1000
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6A5M1O1026472
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2008 15:22:01 +1000
Content-Disposition: inline
In-Reply-To: <3.0.6.32.20080709150004.01bd9858@pop.west.cox.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 09, 2008 at 03:00:04PM +0000, Gary Hawco wrote:
> Segfaults have returned with snapshots compiled after 070908--0010hrs GMT.
> 
> That one worked fine.
> 
> The next one I tried (070908/0025hrs GMT) caused segfaults in both Gentoo &
> Slackware (a first for Slackware) when trying to untar
> linux-2.6.26-rc9.tar.bz2 tarball)
> 
> I then rolled back two snapshots to 070908/0012hrs GMT) and it segfaulted
> in both operating systems doing same untarring function.
> 
> So, apparently, since 0010snapshot
> (ext4-patch-queue-bfb23cf4cd345552c774142cb10ac1225caf35f5.tar.gz) works fine
> 
> and 0012snapshot
> (ext4-patch-queue-be66b0c5c3f4293176301c0ddcb8db95b0576cb4.tar.gz)
> segfaults, the 
> Add ext4-fix-mb_find_next_bit-return.patch must be the culprit.

Is your file system full when this happens ? Which user space call cause
the segfault ? An strace should be able to help you find that. We
actually have modified ext4 to give SIGBUS when we hit ENOSPC during
mmap write. For ex:

root:/ext4# /root/mmaptest ./test4  0 100
mmaping 0 to 100
Bus error (core dumped)
root:/ext4# 

-aneesh
