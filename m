From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [Bug 38642] New: ext4 timestamp format unable to uniquely
 represent times
Date: Sat, 25 Aug 2012 12:01:05 -0400
Message-ID: <20120825160105.GA6111@thunk.org>
References: <bug-38642-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: bugzilla-daemon@bugzilla.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46816 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606Ab2HYRve (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 25 Aug 2012 13:51:34 -0400
Content-Disposition: inline
In-Reply-To: <bug-38642-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 01, 2011 at 03:05:38PM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> 
> The presence of the extra bits in the ext4 timestamps implies a desire to
> represent file times to sub-second accuracy. Unfortunately, standard posix
> timestamps are not uniformly 1 SI second long, due to the presence of leap
> seconds. For example, the Posix timestamp 1230768000 corresponds to the UTC
> times "2008-12-31 23:59:60" and "2009-01-01 00:00:00".
> 
> Since there are only 30 bits in the nanosecond field, ext4 cannot accurately
> keep track of file times during a leap second.

This is something which is fundamentally true with how time is handled
by Linux and POSIX systems in general.  The gettimeofday(2) function
will not return values greater than or equal to 10**6 in the tv_usec
field.  Instead, the tv_sec field will simply not change during the
leapsecond, and tv_usec field will cycle from 999999 to 0.

The kernel doesn't do anything special for leap seconds at all; it
doesn't know about them.  Since ext4 file system driver is in the
kernel, the same is logically true for ext4.  The ext4 driver will
call the internal equivalent of gettimeofday(2), and we will never get
subsecond values which are larger than 999999 usecs.  Hence, the fact
that we have only 30 bits of nanonsecond fields is fine.

Regards,

      	     	  	      	      	 - Ted

P.S.  It is the responsibility of ntp to forcibly adjust the system
clock and create a discontinuity in the times returned by time(2) and
gettimeofday(2) during the leap second.  It's because of this that all
manner of computer malfunctions can happen during the leap second.  In
particular, distributed systems which rely on the time stamp to
enforce uniqueness can go completely haywire (since most software used
by distributed systems have no idea that a leapsecond is coming and
make no allowances for it --- this includes time-based UUIDs created
by libuuid, BTW, which *is* being used by open source distributed
systems, at least two of which can create tens of thousands of UUID's
per second, and hence the chance of collisions are extremely high
during the leap second).

For this reason, Google internally uses ntp servers which perform a
"leap smear" during the 24 hours before the leap second.  During that
time, Google's ntp slows down the system clock and spreads out the
leapsecond across the entire day.  This allows us to avoid the
discontinuity problem, although it means that Google's ntp servers are
not compatible with the rest of the ntp servers on the network during
the day before the leap second.

(This is one of the reasons why people should NOT try using any NTP
servers they might find in Google's DNS, BTW, since it is incompatible
with all other NTP servers during the day before the leap second, and
bad things will happen if you associate with "leap smear" ntp servers
and normal ntp servers at the same time.  The other reason is it is an
unadvertised and unsupported service, for Google's internal use only,
and as such there is no SLA --- it can disappear at any time.)
