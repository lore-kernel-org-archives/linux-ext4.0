From: Andreas Dilger <andreas.dilger@oracle.com>
Subject: Re: [PATCH,RFC] Adding quotacheck functionality to e2fsck
Date: Fri, 26 Mar 2010 01:01:35 -0600
Message-ID: <9E7C0FF6-B02F-4470-B70A-4DBF5D5D6E0E@oracle.com>
References: <E1NuxHe-0005cj-JN@closure.thunk.org> <20100326004738.GJ3145@quack.suse.cz> <20100326033824.GC21658@thunk.org>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:48431 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab0CZHCt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 26 Mar 2010 03:02:49 -0400
In-Reply-To: <20100326033824.GC21658@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-03-25, at 21:38, tytso@mit.edu wrote:
> On Fri, Mar 26, 2010 at 01:47:38AM +0100, Jan Kara wrote:
>>  This is definitely a move in the right direction. I'd be even  
>> happier
>> if e2fsck would write quota file directly - then we could just make
>> quota files hidden inodes, start doing quota accounting immediately
>> on mount and always do quota journaling. That would save us quite  
>> some
>> trouble in kernel. The only problem with this is that we'd need to  
>> pull
>> knowledge about quota formats in e2fsck...

I totally agree.  Having to run quotacheck when the quota is journaled  
is a major time waster on a large filesystem.  This is doubly true  
since the only time the journal should ever get inconsistent is when  
e2fsck changes it.

> Yes, quite possibly.  How quota is currently is set up is quite
> kludgy, with magic options that do nothing but display magic options
> in /proc/mounts, just in case that's a hard link to /etc/mtab.  It
> also looks like that some of the magic is in various distribution's
> init.d scripts, and so while I very much want to clean things up, it
> wasn't clear to me how much flexibility we would have without worrying
> about breaking the init scripts for Debian, Ubuntu, RHEL, SLES,
> Fedora, Open SuSE, etc.
>
> There may also be other programs that depend on the existence of
> aquota.user, and may be reading and writing them in various random
> ways, and there is the question of how do we provide compatibility
> with these other programs, some of which may not be within quotatools,
> but in various magic virtualization or container or cluster management
> systems....

If the quota file is already present as a regular file, I don't think  
it would be terrible to leave it in place, but to create new quota  
files as hidden files.
It also would be nice to always enable quota journaing in ext4, since  
I don't think this does any harm, and if quotacheck isn't run then at  
least there a good chance the quotas are still correct.

> So maintaining compatibility between older kernels, newer kernels,
> older init scripts, new init scripts, etc. may make changing the quota
> system quite difficult.  I would like to do as much cleanup as we can,
> though.
>
> One question I have --- do we really have to support the 2 or 3
> different quota variants?  How many people/distributions are still
> using the original old quota system?  One thing that worries me is
> that it looks like the old (non-journaled) quota system may be the
> primary system still being used by Canonical and Debian...  I really
> do hope I'm wrong, but there are a bunch of HOWTO's that still people
> to use usrquota and grpquota in /etc/fstab, and not the newer
> usrjquota and grpjquota mount options.

If there isn't a reason to continue using unjournaled quota (i.e. it  
doesn't break to just move to journaled quota everywhere), then these  
could just become aliases for the journaled quota implementation.  The  
other alternative is to deprecate these options in the next kernel and  
have it print out a warning on the console to tell the user to switch  
over to the journaled version.


Cheers, Andreas
--
Andreas Dilger
Principal Engineer, Lustre Group
Oracle Corporation Canada Inc.

