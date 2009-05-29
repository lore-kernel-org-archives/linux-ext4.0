From: Theodore Tso <tytso@mit.edu>
Subject: Re: I lost 15G from ext4 fsck failures tonight!
Date: Fri, 29 May 2009 09:58:27 -0400
Message-ID: <20090529135827.GE26625@mit.edu>
References: <23774225.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: ed1989 <edshrock@live.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50478 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758842AbZE2N6c (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 29 May 2009 09:58:32 -0400
Content-Disposition: inline
In-Reply-To: <23774225.post@talk.nabble.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, May 28, 2009 at 09:55:42PM -0700, ed1989 wrote:
> 
> I moved some data off of a 115G ext4 filesystem on an LVM logical volume. 
> Then I resized the ext4 filesystem.  Unfortunately, 15G of the remaining 95G
> in data was lost to /lost+found due to repeated fsck errors.

What version of e2fsprogs and the kernel are you using?  Can you give
us details about what filesystem corruptions was reported by fsck?
Also, did the system crash, or did you reboot, between the resize and
when fsck showed errors?  Was there anything in the system logs?

Note that the data is not lost if the files are moved to /lost+found.
This happens when a containing directory has been destroyed or
corrupted.  But the files in the directory are still there; they've
just been moved to the lost+found directory.  Asssociating the names
with the inode numbers can be tricky --- although for directories that
get moved to lost+found, usually you can use the locatedb to figure
out the name of the parent directory.  (i.e., if the directory
contains files "bash", "ls", "rm", then the name of the directory was
likely "/bin"; if the directory contains file such as "motd",
"passwd", and "resolv.conf", then it it's likely that the directory
was originally named "/etc"; the locatedb can be used to figure this
out).  For other files, you'll have to figure out by using the "file"
command to determine the file type, and then looking at in-band data
(for example, the ID3 information in mp3 file).

> I have also had the problem of ext4 destroying my kde4 configuration files
> so that my kde4 desktop would revert back to the defaults occasionally.
> 
> I don't see what the benefit of ext4 really is, when data loss doesn't seem
> to be a concern among ext4 developers.  I would expect that data loss should
> be the primary concern.

A hueristic to work around bugs in KDE has been introduced in 2.6.29;
you may not know this, but I created the workaround because I know it
would take a long time to fix the broken applications, *before* I
started advocating that application programmers fix their broken
programs.  These workarounds were backported to both the Fedora 11 and
Ubuntu Jaunty kernels.  I don't know what version of the kernel you
are using, but I'm guessing it must be an older one.  In any case, I
care very much about data loss; that's why I *both* implemented a
workaround, *and* advocated that application programmers fix their
buggy programs.

But if you want to go back to ext3, or use some other filesystem,
please feel free.  It's all about free choice, after all.

Regards,

						- Ted
