From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 38642] ext4 timestamp format unable to uniquely represent times
Date: Sat, 25 Aug 2012 17:51:24 +0000 (UTC)
Message-ID: <20120825175124.A271011FC6F@bugzilla.kernel.org>
References: <bug-38642-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.19.201]:37183 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab2HYRv2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 25 Aug 2012 13:51:28 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id D58DC2032C
	for <linux-ext4@vger.kernel.org>; Sat, 25 Aug 2012 17:51:26 +0000 (UTC)
Received: from bugzilla.kernel.org (unknown [198.145.19.217])
	by mail.kernel.org (Postfix) with ESMTP id 0E18D2031F
	for <linux-ext4@vger.kernel.org>; Sat, 25 Aug 2012 17:51:25 +0000 (UTC)
In-Reply-To: <bug-38642-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

https://bugzilla.kernel.org/show_bug.cgi?id=38642





--- Comment #1 from Theodore Tso <tytso@mit.edu>  2012-08-25 17:51:24 ---
On Fri, Jul 01, 2011 at 03:05:38PM +0000, bugzilla-daemon@bugzilla.kernel.org
wrote:
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

-- 
Configure bugmail: https://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
