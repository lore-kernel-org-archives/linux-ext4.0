From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH][RFC] JBD2: Use DebugFS for jbd2 debug config option.
Date: Mon, 11 Jun 2007 17:22:46 -0500
Message-ID: <20070611172246.606aed4c@gara>
References: <20070607234537.56537f85@gara>
	<20070608070812.GE5181@schatzie.adilger.int>
	<20070608225741.58dc7459@gara>
	<1181599482.4475.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger@clusterfs.com>, linux-ext4@vger.kernel.org
To: cmm@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:34616 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618AbXFKWXN (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Jun 2007 18:23:13 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e33.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5BMNDrp016097
	for <linux-ext4@vger.kernel.org>; Mon, 11 Jun 2007 18:23:13 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5BMNC6V247078
	for <linux-ext4@vger.kernel.org>; Mon, 11 Jun 2007 16:23:12 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5BMNCwa012014
	for <linux-ext4@vger.kernel.org>; Mon, 11 Jun 2007 16:23:12 -0600
In-Reply-To: <1181599482.4475.12.camel@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 11 Jun 2007 15:04:42 -0700
Mingming Cao <cmm@us.ibm.com> wrote:

> On Fri, 2007-06-08 at 22:57 -0500, Jose R. Santos wrote:
> > On Fri, 8 Jun 2007 01:08:12 -0600
> > Andreas Dilger <adilger@clusterfs.com> wrote:
> > 
> > > On Jun 07, 2007  23:45 -0500, Jose R. Santos wrote:
> > > > The jbd2-debug file used to be located in /proc/sys/fs/jbd2-debug, but
> > > > create_proc_entry() does not do lookups on file names with more that one
> > > > directory deep.  This causes the entry creation to fail and hence, no proc
> > > > file is created.  This patch moves the file to /proc/jbd2-degug.
> > > > 
> > > > The file could be move to /proc/fs/jbd2/jbd2-debug, but it would require
> > > > some minor alterations to the jbd-stats patch.
> > > 
> > > I don't think we really want to be adding top-level files in /proc.
> > > What about using the "debugfs" filesystem (not to be confused with
> > > the e2fsprogs 'debugfs' command)?
> > 
> > How about this then?  Moved the file to use debugfs as well as having
> > the nice effect of removing more lines than what it adds.
> > 
> Shall we do this for ext3 as well?

We should since its broken in the old JBD code as well.  I'll make a
patch and post it to fsdevel and LKML.

-JRS
