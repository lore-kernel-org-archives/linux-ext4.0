From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: jbd2_handle and i_data_sem circular locking dependency detected
Date: Mon, 4 Feb 2008 21:07:45 +0530
Message-ID: <20080204153745.GA6798@skywalker>
References: <20080204101228.GA1939@skywalker> <200802041023.16998.jbacik@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
	Andreas Dilger <adilger@sun.com>,
	Mingming Cao <cmm@us.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Josef Bacik <jbacik@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:41291 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbYBDPh4 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Feb 2008 10:37:56 -0500
Received: from d23relay03.au.ibm.com (d23relay03.au.ibm.com [202.81.18.234])
	by e23smtp03.au.ibm.com (8.13.1/8.13.1) with ESMTP id m14FbNWN009384
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 02:37:23 +1100
Received: from d23av04.au.ibm.com (d23av04.au.ibm.com [9.190.235.139])
	by d23relay03.au.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m14FbroW3862616
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 02:37:53 +1100
Received: from d23av04.au.ibm.com (loopback [127.0.0.1])
	by d23av04.au.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m14FbqC9016669
	for <linux-ext4@vger.kernel.org>; Tue, 5 Feb 2008 02:37:53 +1100
Content-Disposition: inline
In-Reply-To: <200802041023.16998.jbacik@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 04, 2008 at 10:23:16AM -0500, Josef Bacik wrote:
> On Monday 04 February 2008 5:12:28 am Aneesh Kumar K.V wrote:
> > Hi,
> >
> > This is with the new ext3 -> ext4 migrate code added. The recently added
> > lockdep for jbd2 helped to find this out. We want to hold the i_data_sem
> > on the ext3 inode during migration to prevent walking the ext3 inode
> > when it is being converted to ext4 format. Also we want to avoid
> > file truncation and new blocks being added while converting to ext4.
> > Also we dont want to reserve large number of credits for journal.
> > Any idea how to fix this ?
> >
> 
> Hello,
> 
> Seems you should be taking the i_data_sem after starting the journal in 
> ext4_ext_migrate.  I haven't looked at this stuff too much, but everywhere I 
> see i_data_sem taken its within a journal_start/journal_stop.  Here's the 
> patch.  Let me know if I'm way off btw, like I said I'm new to this :).  Thank 
> you,

But that doesn't help. Because we call ext4_journal_restart after taking
i_data_sem. That implies we can sleep waiting for other running
transaction to commit. And if that transaction (in the above example
rm) is waiting for i_data_sem we deadlock.

-aneesh
