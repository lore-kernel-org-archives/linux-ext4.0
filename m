From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Bugme-new] [Bug 9911] New: fsync blocks concurrent writes to
 file
Date: Thu, 7 Feb 2008 19:14:10 -0800
Message-ID: <20080207191410.ed694bab.akpm@linux-foundation.org>
References: <bug-9911-10286@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: bugme-daemon@bugzilla.kernel.org, llowrey@nuclearwinter.com
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37599 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755886AbYBHDN5 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Feb 2008 22:13:57 -0500
In-Reply-To: <bug-9911-10286@http.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu,  7 Feb 2008 17:40:57 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:

> http://bugzilla.kernel.org/show_bug.cgi?id=9911
> 
>            Summary: fsync blocks concurrent writes to file
>            Product: File System
>            Version: 2.5
>      KernelVersion: 2.6.23.8
>           Platform: All
>         OS/Version: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: ext3
>         AssignedTo: akpm@osdl.org
>         ReportedBy: llowrey@nuclearwinter.com
> 
> 
> Latest working kernel version: none
> Earliest failing kernel version: 2.6.18
> Distribution: RHEL 4 & Fedora 8
> Hardware Environment: Dual Xeon & dual-core Athlon
> Software Environment: Java 1.5.0_14
> Problem Description: Multiple threads append transactions to a single file.
> When fsyncs are issued, no writes complete until the fsync completes. This has
> the effect of yielding the same write rate regardless of how many threads are
> writing to the file. Solaris 10 does not exhibit this problem and scales well
> as additional threads are added.
> 
> I have confirmed this by running strace and witnessing that writes block until
> immediately after the fsync completes.
> 
> When using truss on Solaris I have witnessed multiple writes completing while
> an fsync was in progress.
> 
> Steps to reproduce:
> 
> Open a file for writing.
> Launch multiple threads with each one writing data and followed by an fsync,
> but only if data has been written since the last fsync.
> 
> 
> I have googled this issue substantially and have found no answers.
> 

I supposing teaching java about sync_file_range() would be all too hard.
