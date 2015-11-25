From: bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org (J. Bruce Fields)
Subject: Re: [RFC][PATCH 00/12] Enhanced file stat system call
Date: Wed, 25 Nov 2015 12:51:53 -0500
Message-ID: <20151125175153.GA30335@fieldses.org>
References: <1502878.QisWlqATFu@merkaba>
 <20151120145422.18930.72662.stgit@warthog.procyon.org.uk>
 <4495.1448036915@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Martin Steigerwald <martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>, arnd-r2nGTMty4D4@public.gmane.org,
	linux-afs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4495.1448036915-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Nov 20, 2015 at 04:28:35PM +0000, David Howells wrote:
> Martin Steigerwald <martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org> wrote:
> 
> > Any plans to add limitations of filesystem to the call like maximum file
> > size?  I know its mostly relevant for just for FAT32, but on any account
> > rather than trying to write 4 GiB and then file, it would be good to at some
> > time get a dialog at the beginning of the copy.
> 
> Adding filesystem limits can be done.  I got a shopping list of things people
> wanted a while back and I've worked off of that list.  I can add other things
> - that's on of the reasons I left room for expansion.

I ran across systemd/src/basic/path-util.c:fd_is_mount_point() the other
day, and the contortions it goes through made me wonder if we should
also add mnt_id and/or an is_mountpoint boolean--it's annoying to have
to do name_to_handle_at() (not supported on all filesystems) just to get
mnt_id.

(Looking at it now I see it falls back on reading mount id from
/proc/self/fdinfo/<fd>.  Maybe that's good enough.  May depend on
whether there's a potential user that doesn't want to assume access to
/proc?)

--b.
