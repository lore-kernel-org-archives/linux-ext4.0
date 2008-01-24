From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [RFC] Parallelize IO for e2fsck
Date: Thu, 24 Jan 2008 18:40:37 -0500
Message-ID: <20080124234037.GJ15858@mit.edu>
References: <9Mo9w-7Ws-25@gated-at.bofh.it> <9Mo9w-7Ws-23@gated-at.bofh.it> <9OdWm-7uN-25@gated-at.bofh.it> <9Oi9A-5EJ-3@gated-at.bofh.it> <9OiMg-6IC-1@gated-at.bofh.it> <9OlqL-2xG-3@gated-at.bofh.it> <9Orda-3ub-45@gated-at.bofh.it> <E1JI5vz-0001GG-Vs@be1.7eggert.dyndns.org> <20080124230809.GA29120@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Bodo Eggert <7eggert@gmx.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Andreas Dilger <adilger@sun.com>, Valdis.Kletnieks@vt.edu,
	David Chinner <dgc@sgi.com>,
	Valerie Henson <val@vahconsulting.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger@clusterfs.com>,
	Ric Wheeler <ric@emc.com>
To: Adrian Bunk <bunk@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:49838 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755900AbYAXXlo (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Thu, 24 Jan 2008 18:41:44 -0500
Content-Disposition: inline
In-Reply-To: <20080124230809.GA29120@does.not.exist>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 25, 2008 at 01:08:09AM +0200, Adrian Bunk wrote:
> In practice, there is a small number of programs that are both the
> common memory hogs and should be able to reduce their memory consumption
> by 10% or 20% without big problems when requested (e.g. Java VMs,
> Firefox and databases come into my mind).

I agree, it's only a few processes where this makes sense.  But for
those that do, it would be useful if they could register with the
kernel that would like to know, (just before the system starts
ejecting cached data, just before swapping, etc.) and at what
frequency.  And presumably, if the kernel notices that a process is
responding to such requests with memory actually getting released back
to the system, that process could get "rewarded" by having the OOM
killer less likely to target that particular thread.

AIX basically did this with SIGDANGER (the signal is ignored by
default), except there wasn't the ability for the process to tell the
kernel at what level of memory pressure before it should start getting
notified, and there was no way for the kernel to tell how bad the
memory pressure actually was.  On the other hand, it was a relatively
simple design.

In practice very few processes would indeed pay attention to
SIGDANGER, so I think you're quite right there.

> And from a performance point of view letting applications voluntarily 
> free some memory is better even than starting to swap.

Absolutely.

						- Ted
