From: Joel Becker <jlbec@evilplan.org>
Subject: Re: Proposed design for big allocation blocks for ext4
Date: Fri, 25 Feb 2011 16:03:04 -0800
Message-ID: <20110226000304.GC28214@noexit>
References: <E1PsnrK-0005r5-JH@tytso-glaptop>
 <20110225215924.GA28214@noexit>
 <20110225234002.GA2924@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ted Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:40486 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab1BZADP (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Feb 2011 19:03:15 -0500
Content-Disposition: inline
In-Reply-To: <20110225234002.GA2924@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 25, 2011 at 06:40:02PM -0500, Ted Ts'o wrote:
> On Fri, Feb 25, 2011 at 01:59:25PM -0800, Joel Becker wrote:
> > 
> > 	Why not call it a 'cluster' like the rest of us do?  The term
> > 'blocksize' is overloaded enough already.
> 
> Yes, good point.  Allocation cluster makes a lot more sense as a name.

	Thank you ;-)

> We're going to keep track of what blocks are uninitialized or not on a
> 4k basis.  So that part of the ext4 code doesn't change.

	Ok, good.  We don't have that info, so we enjoy a lot of fun
with the various pagesize/blocksize/clustersize combinations.

> We could add complexity to do suballocations for directories, but KISS
> seems to be a much better idea for now.

	Oh dear God no.

Joel

-- 

"Nobody loves me,
 Nobody seems to care.
 Troubles and worries, people,
 You know I've had my share."

			http://www.jlbec.org/
			jlbec@evilplan.org
