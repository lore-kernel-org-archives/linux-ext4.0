From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH 00/12] Enhanced file stat system call
Date: Fri, 20 Nov 2015 16:28:35 +0000
Message-ID: <4495.1448036915@warthog.procyon.org.uk>
References: <1502878.QisWlqATFu@merkaba> <20151120145422.18930.72662.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-afs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Martin Steigerwald <martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1502878.QisWlqATFu@merkaba>
Content-ID: <4494.1448036915.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

Martin Steigerwald <martin-3kZCPVa5dk2azgQtNeiOUg@public.gmane.org> wrote:

> Any plans to add limitations of filesystem to the call like maximum file
> size?  I know its mostly relevant for just for FAT32, but on any account
> rather than trying to write 4 GiB and then file, it would be good to at some
> time get a dialog at the beginning of the copy.

Adding filesystem limits can be done.  I got a shopping list of things people
wanted a while back and I've worked off of that list.  I can add other things
- that's on of the reasons I left room for expansion.

David
