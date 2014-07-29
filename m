From: "Joseph D. Wagner" <joe@josephdwagner.info>
Subject: Re: dump ext4 performance degrades linearly as disk fills
Date: Tue, 29 Jul 2014 15:48:27 -0700
Message-ID: <2e28fa96c857e7108b73499d2494bd29@josephdwagner.info>
References: <d5c373beb24a9da86986ea43afe13594@josephdwagner.info>
 <53D80A3F.5010807@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Phillip Susi <phillsusi@gmail.com>
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from josephdwagner.info ([72.4.161.242]:56270 "EHLO
	josephdwagner.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237AbaG2XVw (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 29 Jul 2014 19:21:52 -0400
In-Reply-To: <53D80A3F.5010807@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/29/2014 1:55 pm, Phillip Susi wrote:

> Just thought I'd suggest two things you might try:
> 
> 1) dump to /dev/null to make sure it is a read problem, and not a
> problem writing the output file.

It's not a read problem.  It's a write problem.  I confirmed this by 
reformatting the *destination* media from ext4 to xfs.  The problem 
disappears on xfs.  The problem also disappears on ext4 without a 
journal, suggesting the problem is in the journal.

Curiously, formatting with this option also makes the problem disappear:
-E lazy_itable_init=0,lazy_journal_init=0

I filed all of this in a kernel bug report.  You may want to take a 
look.
https://bugzilla.kernel.org/show_bug.cgi?id=78651

> 2) You might try throwing e2defrag at the fs and see if that helps (
> after a full backup of course ). In the past I have seen significant
> slowness when dumping due to my Maildir being fragmented all to hell.
> If you have any sets of large numbers of relatively small files, that
> could be what you are seeing. An e2defrag pass will completely clear
> this up.

Since the problem disappears when using different options on the 
*destination* media, I'm going to assume this is unnecessary for the 
source files.  As for the img file dump creates, all the extents are 128 
MB in size (the maximum extent size on ext4) except for the last one.

Joseph D. Wagner
