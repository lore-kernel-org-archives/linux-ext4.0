From: Ted Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make
 extended file stats available [ver #6]
Date: Thu, 22 Jul 2010 21:21:30 -0400
Message-ID: <20100723012130.GD16373@thunk.org>
References: <20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
 <20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
 <30448.1279800887@redhat.com>
 <E1Obuiy-00C9jr-Al@intern.SerNet.DE>
 <AANLkTikBCXK6uEwWq4f0LvpdoKCPs3jvyFa4Zw4e2J_7@mail.gmail.com>
 <E1Obxpd-00CRIo-SF@intern.SerNet.DE>
 <AANLkTimwIq0pBhCeOjOVjB0yeM3JHOvzVoj9M4ui6al9@mail.gmail.com>
 <20100722162712.GB10352@jeremy-laptop>
 <AANLkTimdFCGSKLn7aGMpBMIauHTsHY7hpAAmpo6uTcnD@mail.gmail.com>
 <19528.60019.28495.655512@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>,
	Jeremy Allison <jra-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: tridge-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <19528.60019.28495.655512-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Jul 23, 2010 at 11:03:47AM +1000, tridge-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org wrote:
> 
> The other big difference from POSIX timestamps is that the
> CreationTime is settable on Windows, and some of the windows UI
> behaviour relies on this.

Well, not POSIX, because POSIX doesn't have CreationTime at all.
BSD's birthtime doesn't allow it to be set, and the question here is
largely philosophical.  Does it literally mean "file creation time" in
terms of when the OS created the file, or does it mean "file" in the
sense of application contents.  For example, if an application edits
the file and saves it out using "write file to foo.new; sync; rename
foo to foo.bak; rename foo.new to foo", should the creation time for
the newly written file "foo" be the time when the editor saved out the
file (i.e., when "foo.new" was created), or copied from the original
file "foo"'s creation time.

This is something (whether or not the application is allowed to set
the creation time) that I think makes sense to be either a filesystem
level mount option, or superblock tunable, or even a per-process
personality flag.

However, I think Linus's idea of using a per-process flag to control
whether or not "ctime" has the original POSIX semantics or some new
"creation time" semantics would lead to a huge amount of confusion.
Given that a number of new filesystems, including both ext4 and btrfs,
have creation time, it makes sense for us to have a fourth timestamp.
Whether or not our creation time is settable or not is a separate
question, and I don't think we need to follow BSD's lead on this.  If
GNOME and/or KDE applications start using it, I could see this
becoming that gets wide adoption fairly quickly.

						- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
