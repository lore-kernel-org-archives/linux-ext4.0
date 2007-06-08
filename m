From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH] JBD2: Change debug file path
Date: Fri, 8 Jun 2007 07:01:47 -0500
Message-ID: <20070608070147.7e021685@gara>
References: <20070607234537.56537f85@gara>
	<20070608070812.GE5181@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:35566 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760597AbXFHMCL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 8 Jun 2007 08:02:11 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l58C27DX029256
	for <linux-ext4@vger.kernel.org>; Fri, 8 Jun 2007 08:02:07 -0400
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l58C265B495490
	for <linux-ext4@vger.kernel.org>; Fri, 8 Jun 2007 08:02:06 -0400
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l58C26ZQ014836
	for <linux-ext4@vger.kernel.org>; Fri, 8 Jun 2007 08:02:06 -0400
In-Reply-To: <20070608070812.GE5181@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 8 Jun 2007 01:08:12 -0600
Andreas Dilger <adilger@clusterfs.com> wrote:

> On Jun 07, 2007  23:45 -0500, Jose R. Santos wrote:
> > The jbd2-debug file used to be located in /proc/sys/fs/jbd2-debug, but
> > create_proc_entry() does not do lookups on file names with more that one
> > directory deep.  This causes the entry creation to fail and hence, no proc
> > file is created.  This patch moves the file to /proc/jbd2-degug.
> > 
> > The file could be move to /proc/fs/jbd2/jbd2-debug, but it would require
> > some minor alterations to the jbd-stats patch.
> 
> I don't think we really want to be adding top-level files in /proc.
> What about using the "debugfs" filesystem (not to be confused with
> the e2fsprogs 'debugfs' command)?

I agree.  Was feeling kind of lazy though and didn't want to to much
time on this issue. :)

I'll look into changing jbd and jbd2 into using debugfs.

-JRS
