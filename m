From: Ted Ts'o <tytso@mit.edu>
Subject: Re: High CPU Utilization When Copying to Ext4
Date: Sun, 26 Jun 2011 23:05:39 -0400
Message-ID: <20110627030539.GF3064@thunk.org>
References: <341DAA96EE3A8444B6E4657BE8A846EA4B3DA126FE@NDJSSCC06.ndc.nasa.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Mccauliff, Sean D. (ARC-PX)[Lockheed Martin Space OPNS]"
	<sean.d.mccauliff@nasa.gov>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44329 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756371Ab1F0DFm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 26 Jun 2011 23:05:42 -0400
Content-Disposition: inline
In-Reply-To: <341DAA96EE3A8444B6E4657BE8A846EA4B3DA126FE@NDJSSCC06.ndc.nasa.gov>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 26, 2011 at 12:33:16PM -0500, Mccauliff, Sean D. (ARC-PX)[Lockheed Martin Space OPNS] wrote:
> Sorry if this is not the correct mailing list for ext4 questions.

-ext3-users, +linux-ext4

> I'm copying terabytes of data from an ext3 file system to a new ext4
> file system.  I'm seeing high CPU usage from the processes
> flush-253:2, kworker-3:0, kworker-2:2, kworker-1:1, and kworker-0:0.
> Does anyone on the list have any idea what these processes do, why
> they are consuming so much cpu time and if there is something that
> can be done about it?  This is using Fedora 15.

You're using Fedora 15, so you're using a 2.6.38 kernel, right?

How are you copying the files?  Are you using cp?  rsync?  NFS?  CIFS?

what sort of files are you copying?  Are they large files, many of
small files?   Are there lots of hard links?  etc.

      	       	   	      	      - Ted


