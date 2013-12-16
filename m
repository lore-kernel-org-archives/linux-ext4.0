From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [Bug 66951] New: filesystems should reserve inodes for root as
 they do disk space
Date: Mon, 16 Dec 2013 11:14:36 -0200
Message-ID: <20131216131434.GA18255@orion.maiolino.org>
References: <bug-66951-13602@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab3LPNOr (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 Dec 2013 08:14:47 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rBGDEl0j016283
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Mon, 16 Dec 2013 08:14:47 -0500
Received: from orion.maiolino.org (ovpn-113-110.phx2.redhat.com [10.3.113.110])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id rBGDEc5G010743
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Mon, 16 Dec 2013 08:14:45 -0500
Content-Disposition: inline
In-Reply-To: <bug-66951-13602@https.bugzilla.kernel.org/>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Sat, Dec 14, 2013 at 12:09:19AM +0000, bugzilla-daemon@bugzilla.kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=66951
> 
>             Bug ID: 66951
>            Summary: filesystems should reserve inodes for root as they do
>                     disk space
>            Product: File System
>            Version: 2.5
>     Kernel Version: 3.11.10
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: enhancement
>           Priority: P1
>          Component: ext4
>           Assignee: fs_ext4@kernel-bugs.osdl.org
>           Reporter: kernelbugs@tecnopolis.ca
>         Regression: No
> 
> I had a runaway non-root user process (Opera browser actually) exhaust all of
> the inodes on my / (root) filesystem (ext4) by creating millions of 10 to 50
> byte cache files in /home (which is not a separate partition on my system). 
> Linux & ext4 happily allowed this program to cripple the whole system until I
> figured out a) inodes were exhausted and b) what app was causing it and where
> they all were, and c) rm -rf them all.
> 
> We all know filesystems like ext2/3/4 reserve a (tunable) amount of space for
> root use only if a disk fills beyond a certain threshold.  I find it shocking
> that a similar mechanism does not exist for inodes.  Most *NIX geeks I know
> also can't believe it.  Do you find it shocking too?
> 
Yes, having an inode amount reserved for root might be good to avoid these
cases.

> One could argue I should have /home on a separate partition, but this is a
> non-solution because all it takes is one user-writable directory in / (root)
> such as /var/tmp.  Sure, then you could say /var should be a separate
> partition, but let's be realistic: 95%+ of systems out there will not have a
> separate /home or /var partition (let alone both).  Also, no distros by default
> create separate partitions for all of these.
> 
Sorry, but you're wrong here.

Almost all good system administrators knows the importance of keep directories
like /home and /var in different filesystems, for simply 2 reasons: 
- Keep system data separated from user data
- /var will store logs, and this might be HUGE in some cases.

And also, most distros I know of keeps /var and /home separated in their default
installations.

So, there is no excuse to keep /home and /var in different filesystems. Even if
you have just a single user, keep a separate /home filesystem is always
recommended.

> One could argue you should have your inode capacity be set so large it would be
> impossible to exhaust it before you run out of disk space.  That point is moot
> because a program could create 0 byte files, thus allowing exhaustion of inodes
> before free space (which would remain unchanged).  Besides, one should be
> allowed to tune their inodes at fs creation time to suit their usage habits as
> monitored over the years (such as looking at their usual NBPI and adding a 2 or
> 4X safety margin).
> 
I agree that change the inode capacity wouldn't make the system behave any
better.

> One could argue you could use quotas, but that seems unreasonable for the
> average guy (like myself) to do on their home desktop computer that only they
> use.
> 
Agreed indeed.

> Can ext2/3/4 and the kernel be modified to reserve a (tunable) number of inodes
> for root just as it does for disk space?
> 
I'm not sure how feasible it is or if is there any kind of job being done or
already done in this area, but is a good idea and I just added it to my TODO
list.

In the meantime, this isn't just a matter of how ext4 behaves regarding the
amount of inode, but looks like a BUG in your browser, or maybe you're accessing
a site which creates thousands of inodes?

-- 
Carlos
