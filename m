From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [4.1-rc] File was modified, but mtime stayed the same (according
 to unison)
Date: Tue, 9 Jun 2015 12:04:55 -0400
Message-ID: <20150609160455.GS19168@thunk.org>
References: <20150609104330.GA29980@amd>
 <20150609151209.GR19168@thunk.org>
 <20150609153429.GA704@amd>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
	kernel list <linux-kernel@vger.kernel.org>, jack@suse.cz
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150609153429.GA704@amd>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 09, 2015 at 05:34:29PM +0200, Pavel Machek wrote:
> 
> Ok, I guess mmap() can explain this. So... basically mtime is useless
> in detecting if file have been updated?
> 
> Thats... not welcome.

Using mtime to detect if a file has been updated if there is a process
updating the file at the same time you are trying to take snapshots
and using mtime is inherently racy.

This was much more obvious for file systems with a one second mtime
granularity, but because of mmap(2), it's still not true even if you
have a file system with nanosecond timestamps.

> I see that constantly updating on-disk timestamp is not
> feasible. Could we do something like
> 
>   on page_being_mmapped_rw:
> 	     file.mtime = "future".
> 
>   on last_rw_mmap_disappearing:
>   	     file.mtime = now().
> 
>   stat():
> 	if file.mtime != "future":
> 		result.mtime = file.mtime
> 	else:
> 		result.mtime = now()
> 
> ? I see making stat slower is not welcome, but having to read complete
> files to determine if they were modified is even worse than that...

Doing this would violate POSIX, and would probably break other
programs that would be surprised when mtime goes backwards.  I suspect
a better thing to do is to add a new system call interface which
allows a userspace process to query whether a file is either (a)
opened for read, (b) opened for write, and/or (c) mmap'ed.  Not all
file systems would be able to return this bitfield --- for example, it
wouldn't be possible to do this for NFS, for example, and it's not
clear how this should or could work for overlayfs.

Unison could then be modified to use this new system call interface,
so it can take special care if the file is currently opened for write
or mmap'ed.  Note that because of the mtime granularity issues, which
can be constrained by the on-disk file system field, as well as the
granularity of the hardware clocks available to the system, unison
could get fooled nonetheless.

Regards,

						- Ted
