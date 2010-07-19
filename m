From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended
	file stats available [ver #6]
Date: Mon, 19 Jul 2010 10:46:55 -0700
Message-ID: <AANLkTikxHJgguNn6EOK6fX53xYSRPmcNjIeGSTigQ9qu@mail.gmail.com>
References: <20100715021709.5544.64506.stgit@warthog.procyon.org.uk>
	<20100715021712.5544.44845.stgit@warthog.procyon.org.uk>
	<AANLkTikuzYqYpGHcubb7QVciZW0dNFjOG82qIwy5M4gO@mail.gmail.com>
	<10783.1279556132@redhat.com>
	<AANLkTinVns77R7yCCh-lydd0eQufdAF9O2OaWmCL7uSn@mail.gmail.com>
	<11817.1279560400@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <11817.1279560400-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Jul 19, 2010 at 10:26 AM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> w=
rote:
>
>> Ask your samba people, for example, if they'd _ever_ do just a "xsta=
t()"?
>
> I suspect they would, though maybe they can say otherwise. =A0What ab=
out SMB
> directory enumeration? =A0I believe that is effectively getdents-with=
-stat.
> Having to do open+stat for each file for that would be painful.

Yeah, but do you need xstat information at all for something like
that? Most people try very hard to make do with the information
returned by readdir itself (d_type and inode number), because if you
end up looking up each name you've already pretty much lost in a
performance model.

(And I do agree that a "readdirplus()" is probably something that a
lot of server people would find useful, but obviously that's another
cross-filesystem nightmare. Only a few filesystems can cheaply give
you anything but d_type/d_ino, and not all do even that),

                      Linus
