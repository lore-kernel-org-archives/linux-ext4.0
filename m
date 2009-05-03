From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 1/2] vfs: call file_ioctl call for directories.
Date: Sun, 3 May 2009 16:30:37 -0400
Message-ID: <20090503203037.GA17044@mit.edu>
References: <1239806343-14219-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20090502230638.GA12368@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:42807 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466AbZECUar (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 3 May 2009 16:30:47 -0400
Content-Disposition: inline
In-Reply-To: <20090502230638.GA12368@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 02, 2009 at 07:06:38PM -0400, Theodore Tso wrote:
> On Wed, Apr 15, 2009 at 08:09:02PM +0530, Aneesh Kumar K.V wrote:
> > Most of the ioctl callback in file_ioctl should be done even
> > for directories. For ext4 fiemap should work even for directories.
> > Similarly FIGETBSZ  should work for directories. For bmap filefrag command
> > doesn't do the ioctl if the type is not a regular file.
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> 
> Thanks, I've pulled this into the ext4 patch queue.
> 

I've had to remove this from the ext4 patch queue --- it causes udevd
to spin in an endless loop:
         
  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 2865 root      16  -4  2220  572  312 R   99  0.0  11:42.06 udevd  

<tytso.root@mini-me> {/home/tytso}, level 2  
498# strace -p 2865 | head -10
Process 2865 attached - interrupt to quit
ppoll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=3, events=POLLIN}], 3, NULL, [], 8) = 1 ([{fd=3, revents=POLLIN}])
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
ioctl(3, FIONREAD, [0])                 = 0
rt_sigprocmask(SIG_SETMASK, ~[RTMIN RT_1], [], 8) = 0
ppoll([{fd=4, events=POLLIN}, {fd=5, events=POLLIN}, {fd=3, events=POLLIN}], 3, NULL, [], 8) = 1 ([{fd=3, revents=POLLIN}])
rt_sigprocmask(SIG_SETMASK, [], NULL, 8) = 0
ioctl(3, FIONREAD, [0])                 = 0
   ...

<tytso.root@mini-me> {/home/tytso}, level 2  
499# ls -l  /proc/2865/fd
total 0
0 lrwx------ 1 root root 64 2009-05-03 16:14 0 -> /dev/null
0 lrwx------ 1 root root 64 2009-05-03 16:14 1 -> /dev/null
0 lrwx------ 1 root root 64 2009-05-03 16:14 2 -> /dev/null
0 lr-x------ 1 root root 64 2009-05-03 16:14 3 -> inotify
0 lrwx------ 1 root root 64 2009-05-03 16:14 4 -> socket:[8026]
0 lrwx------ 1 root root 64 2009-05-03 16:14 5 -> socket:[8027]

I haven't had time to investigate more deeply than this.  My guess on
quick examination is that the inotify file descriptor must be a
directory, and using the FIONREAD ioctl from file_ioctl is disastrous
for udevd.

Aneesh, do you have time to look at this, since this was originally
your patch?  Clearly we can't push this if it causes this regression
with udevd.  Maybe we'd be better off simply adding an FIEMAP and
FIGETBSZ case statements to vfs_ioctl, explicitly just for
directories?

						- Ted
