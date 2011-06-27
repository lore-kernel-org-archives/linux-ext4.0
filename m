From: Lukas Czerner <lczerner@redhat.com>
Subject: Re: High CPU Utilization When Copying to Ext4
Date: Mon, 27 Jun 2011 11:24:24 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1106271120090.3845@dhcp-27-109.brq.redhat.com>
References: <341DAA96EE3A8444B6E4657BE8A846EA4B3DA126FE@NDJSSCC06.ndc.nasa.gov> <20110627030539.GF3064@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "Mccauliff, Sean D. (ARC-PX)[Lockheed Martin Space OPNS]"
	<sean.d.mccauliff@nasa.gov>, linux-ext4@vger.kernel.org
To: "Ted Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30852 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757408Ab1F0JYb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Jun 2011 05:24:31 -0400
In-Reply-To: <20110627030539.GF3064@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 26 Jun 2011, Ted Ts'o wrote:

> On Sun, Jun 26, 2011 at 12:33:16PM -0500, Mccauliff, Sean D. (ARC-PX)[Lockheed Martin Space OPNS] wrote:
> > Sorry if this is not the correct mailing list for ext4 questions.
> 
> -ext3-users, +linux-ext4
> 
> > I'm copying terabytes of data from an ext3 file system to a new ext4
> > file system.  I'm seeing high CPU usage from the processes
> > flush-253:2, kworker-3:0, kworker-2:2, kworker-1:1, and kworker-0:0.
> > Does anyone on the list have any idea what these processes do, why
> > they are consuming so much cpu time and if there is something that
> > can be done about it?  This is using Fedora 15.
> 
> You're using Fedora 15, so you're using a 2.6.38 kernel, right?
> 
> How are you copying the files?  Are you using cp?  rsync?  NFS?  CIFS?
> 
> what sort of files are you copying?  Are they large files, many of
> small files?   Are there lots of hard links?  etc.
> 
>       	       	   	      	      - Ted

Also, how high is high CPU usage ? Is ext4lazyinit thread running (ps
aux | grep ext4lazyinit) ? If it is could you try to mount it with '-o
noinit_itable' mount option to see if it helps ?


Thanks!
-Lukas
