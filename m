From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended
	file stats available [ver #6]
Date: Thu, 22 Jul 2010 08:14:42 -0700
Message-ID: <AANLkTikBCXK6uEwWq4f0LvpdoKCPs3jvyFa4Zw4e2J_7@mail.gmail.com>
References: <alpine.LSU.2.01.1007221228260.6115@obet.zrqbmnf.qr>
	<20100715021709.5544.64506.stgit@warthog.procyon.org.uk> <20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
	<30448.1279800887@redhat.com> <E1Obuiy-00C9jr-Al@intern.SerNet.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <E1Obuiy-00C9jr-Al-dqLtpHMqGvUyWpdLl23E4A@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 22, 2010 at 5:17 AM, Volker Lendecke
<Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org> wrote:
> On Thu, Jul 22, 2010 at 01:14:47PM +0100, David Howells wrote:
>> Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org> wrote:
>>
>> > Linux already has a creation time field, it's called otime (there =
is no "b"
>> > in "creation"), and you will find scattered fragments of that all =
over the
>> > kernel (foremost, fs/jfs/, now btrfs, and I also notice sysvipc ha=
ving
>> > something with that name).
>>
>> It is? =A0It's called crtime in Ext4. =A0st_btime, however, would be=
 compatible
>> with BSD's stat, and Samba would just use it by way of autoconf magi=
c if it
>> appeared.
>
> Samba has the following check:
>
> # recent FreeBSD, NetBSD have creation timestamps called birthtime:
> AC_CHECK_MEMBERS([struct stat.st_birthtimespec.tv_nsec])
> AC_CHECK_MEMBERS([struct stat.st_birthtime], AC_CHECK_MEMBERS([struct=
 stat.st_birthtimensec]))
>
> and the supporting code around that. "birth" might also be
> where the "b" comes from :-)

Oh wow. And all of this just convinces me that we should _not_ do any
of this, since clearly it's all totally useless and people can't even
agree on a name.

Let's wait five years and see if there is actually any consensus on it
being needed and used at all, rather than rush into something just
because "we can".

                       Linus
