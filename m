From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Lockup in wait_transaction_locked under memory pressure
Date: Thu, 25 Jun 2015 09:31:38 -0400
Message-ID: <20150625133138.GH14324@thunk.org>
References: <558BD447.1010503@kyup.com>
 <558BD507.9070002@kyup.com>
 <20150625112116.GC17237@dhcp22.suse.cz>
 <558BE96E.7080101@kyup.com>
 <20150625115025.GD17237@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nikolay Borisov <kernel@kyup.com>, linux-ext4@vger.kernel.org,
	Marian Marinov <mm@1h.com>
To: Michal Hocko <mhocko@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:54562 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbbFYNbn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 25 Jun 2015 09:31:43 -0400
Content-Disposition: inline
In-Reply-To: <20150625115025.GD17237@dhcp22.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 25, 2015 at 01:50:25PM +0200, Michal Hocko wrote:
> On Thu 25-06-15 14:43:42, Nikolay Borisov wrote:
> > I do have several OOM reports unfortunately I don't think I can
> > correlate them in any sensible way to be able to answer the question
> > "Which was the process that was writing prior to the D state occuring".
> > Maybe you can be more specific as to what am I likely looking for?
> 
> Is the system still in this state? If yes I would check the last few OOM
> reports which will tell you the pid of the oom victim and then I would
> check sysrq+t whether they are still alive. And if yes check their stack
> traces to see whether they are still in the allocation path or they got
> stuck somewhere else or maybe they are not related at all...
> 
> sysrq+t might be useful even when this is not oom related because it can
> pinpoint the task which is blocking your waiters.

In addition to sysrq+t, the other thing to do is to sample sysrq-p a
few half-dozen times so we can see if there are any processes in some
memory allocation retry loop.  Also useful is to enable soft lockup
detection.

Something that perhaps we should have (and maybe GFP_NOFAIL should
imply this) is for places where your choices are either (a) let the
memory allocation succeed eventually, or (b) remount the file system
read-only and/or panic the system, is in the case where we're under
severe memory pressure due to cgroup settings, to simply allow the
kmalloc to bypass the cgroup allocation limits, since otherwise the
stall could end up impacting processes in other cgroups.

This is basically the same issue as a misconfigured cgroup which as
very tiny disk I/O and memory allocated to it, such that when a
process in that cgroup does a directory lookup, VFS locks the
directory *before* calling into the file system layer, and then if
cgroup isn't allow much in the way of memory and disk time, it's
likely that the directory block has been pushed out of memory, and on
a sufficiently busy system, the directory read might not happen for
minutes or *hours* (both because of the disk I/O limits as well as the
time needed to clean memory to allow the necessary memory allocation
to succeed).

In the meantime, if a process in another cgroup, with plenty of
disk-time and memory, tries to do anything else with that directory,
it will run into locked directory mutex, and *wham*.  Priority
inversion.  It gets even more amusing if this process is the overall
docker or other cgroup manager, since then the entire system is out to
lunch, and so then a watchdog daemon fires, and reboots the entire
system....

       		       	      	  	  - Ted
