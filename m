From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [Bug 34302] Errors from kjournald
Date: Tue, 3 May 2011 10:59:26 -0600
Message-ID: <47364D7F-9BF3-4E0D-9F00-425C3061043C@dilger.ca>
References: <bug-34302-13602@https.bugzilla.kernel.org/> <201105031627.p43GRRQo017978@demeter1.kernel.org>
Mime-Version: 1.0 (iPhone Mail 8H7)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "bugzilla-daemon@bugzilla.kernel.org"
	<bugzilla-daemon@bugzilla.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from shawmail.shawcable.com ([64.59.128.220]:3664 "EHLO
	mail.shawcable.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab1ECQ7Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 3 May 2011 12:59:24 -0400
In-Reply-To: <201105031627.p43GRRQo017978@demeter1.kernel.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-05-03, at 10:27 AM, bugzilla-daemon@bugzilla.kernel.org wrote:
> The final message of concern was 
> 
> May  3 01:40:09 fawkes kernel: [309464.781078] ata8.00: exception Emask 0x0
> SAct 0x2 SErr 0x0 action 0x6 frozen
> May  3 01:40:09 fawkes kernel: [309464.781091] ata8.00: failed command: READ
> FPDMA QUEUED
> May  3 01:40:09 fawkes kernel: [309464.781107] ata8.00: cmd
> 60/08:08:47:0a:ab/00:00:45:00:00/40 tag 1 ncq 4096 in
> May  3 01:40:09 fawkes kernel: [309464.781111]          res
> 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> May  3 01:40:09 fawkes kernel: [309464.781118] ata8.00: status: { DRDY }
> May  3 01:40:09 fawkes kernel: [309464.781131] ata8: hard resetting link
> May  3 01:40:10 fawkes kernel: [309465.112103] ata8: SATA link up 6.0 Gbps
> (SStatus 133 SControl 300)
> May  3 01:40:10 fawkes kernel: [309465.119531] ata8.00: configured for UDMA/133
> May  3 01:40:10 fawkes kernel: [309465.119543] ata8.00: device reported invalid
> CHS sector 0
> May  3 01:40:10 fawkes kernel: [309465.119559] ata8: EH complete

This looks like a problem with your disk. 

> I am not 100% sure which disk ata8 corresponds to.  I tried looking through the
> boot log to figure out the device assignments, but it was a bit confusing, It
> appears that ata8.00 is one of the source raid disks.  If so, I wonder why it
> got reset?

One possibility is if the source disks share the SATA controller with the target they may both be blocked at the same time.  

Cheers, Andreas