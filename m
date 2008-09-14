From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 11564] New: ext3 I/O errors when <4096
 blocksize on certain hardware
Date: Sun, 14 Sep 2008 00:14:33 -0700
Message-ID: <20080914001433.c843cc74.akpm@linux-foundation.org>
References: <bug-11564-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: bugme-daemon@bugzilla.kernel.org, mrmazda@ij.net
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40901 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750904AbYINHOj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Sep 2008 03:14:39 -0400
In-Reply-To: <bug-11564-10286@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


(switched to email.  Please respond via emailed reply-to-all, not via the
bugzilla web interface).

On Sat, 13 Sep 2008 19:20:35 -0700 (PDT) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=11564
> 
>            Summary: ext3 I/O errors when <4096 blocksize on certain hardware
>            Product: File System
>            Version: 2.5
>      KernelVersion: 2.6.27
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: ext3
>         AssignedTo: akpm@osdl.org
>         ReportedBy: mrmazda@ij.net
> 
> 
> Latest working kernel version:2.6.17
> Earliest failing kernel version:2.6.18
> Distribution:Mandriva, OpenSUSE
> Hardware Environment: PIII-700 on i440BX (100FSB Tyan S1846)
> piix/sym53c8xx (SYM8751SP)
> dysfunctional HD: Quantum Atlas III QM39100TD-SW Rev: N1B0
> OK HD: IBM DPSS 309170; 07N3120; MLC: PS0S96 (Ultrastar)
> OK HD #2: 60G Seagate Barracuda PATA on piix
> Software Environment:typical, except  all partitions formatted ext3 -I128 &
> -b1024 or -b2048 due to their small size (4.8G or less)
> Problem Description:
> Tail of most recent (Factory 2.6.27-rc6) /var/log/messages:
> Sep 13 21:29:23 xxxxx kernel: sd 0:0:1:0: [sda] Result: hostbyte=DID_SOFT_ERROR
> driverbyte=DRIVER_OK,SUGGEST_OK
> Sep 13 21:29:23 xxxxx kernel: end_request: I/O error, dev sda, sector 1810985
> Sep 13 21:29:23 xxxxx kernel: sd 0:0:1:0: [sda] Result: hostbyte=DID_SOFT_ERROR
> driverbyte=DRIVER_OK,SUGGEST_OK
> Sep 13 21:29:23 xxxxx kernel: end_request: I/O error, dev sda, sector 1811039
> Sep 13 21:29:23 xxxxx kernel: JBD: Detected IO errors while flushing file data
> on sda7
> Sep 13 21:29:23 xxxxx kernel: JBD: Detected IO errors while flushing file data
> on sda7
> 
> Similar errors occur with other post-2.6.17 kernels. Typical result is rpm
> database corruption (see e.g. https://qa.mandriva.com/show_bug.cgi?id=32547 not
> reported by me) making system very difficult to use.
> 
> I've run current Cookers on this hardware combination for several years, but
> just over a year ago started having trouble when the 2.6.17 kernel was
> upgraded. I ran the manufacturer's QDPS diagnostics on the Quantum shortly
> after the problem appeared about 13 or so months ago, and again a few days ago,
> both times OK according to QDPS. I ran the LSI controller's format program on
> it a few days ago too. I then tried installing fresh Mandriva 2007.1 (complete
> success) and OpenSUSE 10.2 (limited number of errors of this type). Trying to
> do a current install of Cooker or Factory are hopeless. I tested Factory by
> copying a Factory/11.0 installation from the PATA to sda7 on SCSI, then trying
> to update to current Factory, while Cooker was on sda7 for several years. The
> problem simply did and does not exist with the Mandriva 2.6.17 and old kernels
> using the Atlas III. I tried cloning the Atlas III to the Ultrastar, and cannot
> reproduce using either the Barracuda or the Ultrastar. Trying a different SCSI
> cable didn't help.
> 
> Steps to reproduce:
> Try to use a wrong hardware combination.
> 

