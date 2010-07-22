From: Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended
 file stats available [ver #6]
Date: Thu, 22 Jul 2010 15:05:22 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007221457120.25261@obet.zrqbmnf.qr>
References: <alpine.LSU.2.01.1007221228260.6115@obet.zrqbmnf.qr> <20100715021709.5544.64506.stgit@warthog.procyon.org.uk> <20100715021712.5544.44845.stgit@warthog.procyon.org.uk> <30448.1279800887@redhat.com> <E1Obuiy-00C9jr-Al@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Volker Lendecke <Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E1Obuiy-00C9jr-Al-dqLtpHMqGvUyWpdLl23E4A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Thursday 2010-07-22 14:17, Volker Lendecke wrote:
>On Thu, Jul 22, 2010 at 01:14:47PM +0100, David Howells wrote:
>> Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org> wrote:
>> 
>> > Linux already has a creation time field, it's called otime (there is no "b"
>> > in "creation"), and you will find scattered fragments of that all over the
>> > kernel (foremost, fs/jfs/, now btrfs, and I also notice sysvipc having
>> > something with that name).
>> 
>> It is?  It's called crtime in Ext4.  st_btime, however, would be compatible
>> with BSD's stat, and Samba would just use it by way of autoconf magic if it
>> appeared.

Of course you can find remnants of btime in Linux's BSD-style task 
accounting, but Linux always looked more like SysV than BSD, speaking 
for otime. And if you are using autoconf, the cost of using otime over 
btime seems the same.

>Samba has the following check:
>
># recent FreeBSD, NetBSD have creation timestamps called birthtime:             
>AC_CHECK_MEMBERS([struct stat.st_birthtimespec.tv_nsec])
>AC_CHECK_MEMBERS([struct stat.st_birthtime], AC_CHECK_MEMBERS([struct stat.st_birthtimensec]))
>
>and the supporting code around that. "birth" might also be
>where the "b" comes from :-)

Well, in all reference to the Matrix movie, files aren't born. Except 
for Directory Default ACLs and possibly security labels, they usually 
don't inherit either :)  And on a CS level, it's more like copy than 
inherit, because if the parent changes, the file does not (with the 
potential exception of security relabeling, bla).
