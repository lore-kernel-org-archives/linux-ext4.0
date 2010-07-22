From: Greg Freemyer <greg.freemyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended
	file stats available [ver #6]
Date: Thu, 22 Jul 2010 12:06:22 -0400
Message-ID: <AANLkTimsjARdMfnvFRSyy6gakCtVhGRBbyauVTc_Cuwt@mail.gmail.com>
References: <alpine.LSU.2.01.1007221228260.6115@obet.zrqbmnf.qr>
	<20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
	<20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
	<30448.1279800887@redhat.com>
	<E1Obuiy-00C9jr-Al@intern.SerNet.DE>
	<AANLkTikBCXK6uEwWq4f0LvpdoKCPs3jvyFa4Zw4e2J_7@mail.gmail.com>
	<E1Obxpd-00CRIo-SF@intern.SerNet.DE>
	<AANLkTimwIq0pBhCeOjOVjB0yeM3JHOvzVoj9M4ui6al9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Jan Engelhardt <jengelh-nopoi9nDyk+ELgA04lAiVw@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTimwIq0pBhCeOjOVjB0yeM3JHOvzVoj9M4ui6al9-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 22, 2010 at 11:47 AM, Linus Torvalds
<torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org> wrote:
> On Thu, Jul 22, 2010 at 8:36 AM, Volker Lendecke
> <Volker.Lendecke-3ekOc4rQMZmzQB+pC5nmwQ@public.gmane.org> wrote:
>>
>> The nice thing about this is also that if this is supposed
>> to be fully usable for Windows clients, the birthtime needs
>> to be changeable. That's what NTFS semantics gives you, thus
>> Windows clients tend to require it.
>
> Ok. So it's not really a creation date, exactly the same way ctime
> isn't at all a creation date.
>
> And maybe that actually hints at a better solution: maybe a better
> model is to create a new per-thread flag that says "do ctime updates
> the way windows does them".
>
> So instead of adding another "btime" - which isn't actually what even
> windows does - just admit that the _real_ issue is that Unix and
> Windows semantics are different for the pre-existing "ctime".
>
> The fact is, windows has "access time", "modification time" and
> "creation time" _exactly_ like UNIX. It's just that the ctime has
> slightly different semantics in windows vs unix. So quite frankly,
> it's totally insane to introduce a "birthtime", when that isn't even
> what windows wants, just because people cannot face the actual real
> difference.
>
> Tell me why we shouldn't just do this right?
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0Linus

I haven't been keeping up with this thread, but I believe NTFS has a
number of timestamps, not just 3.

This blog post references 8 in the left hand column.

The 4 standard (most common) ones are:

=46ile last access
=46ile last modified
=46ile created
MFT last modified

My understanding is that "MFT last modified" has semantics very
similar to Linux ctime.

But there is not a generic equivalent to NTFS created.

Thus if trying to have the Linux kernel match NTFS semantics for the
benefit of Samba is the goal, it seems a new field should be preferred
instead of having linux ctime try to do different jobs.

Greg
