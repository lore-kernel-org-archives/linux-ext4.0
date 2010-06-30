From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available [ver #2]
Date: Wed, 30 Jun 2010 14:44:10 +0200
Message-ID: <201006301444.11194.arnd@arndb.de>
References: <201006301346.41902.arnd@arndb.de> <29346.1277892068@redhat.com> <26650.1277900050@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	mcao-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	sjayaraman-l3A5Bk7waGM@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <26650.1277900050-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wednesday 30 June 2010, David Howells wrote:
> Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> 
> > Given a 64 bit flag word, you can start using bits for the version from
> > the top and bits from the bottom for fields:
> 
> I suppose.  It's cleaner, though, to keep them separate.

Yes, but it's a tradeoff. If separating them means you have to add
another structure, I'd prefer having just a flags word with different
kinds of bits. In particular since I don't think we actually need
to worry about wildly different layouts. If struct oldstat had
come with an extensibility concept like what you propose here, we
would not have needed newstat, stat64 and xstat.

> > Alternatively, you can also make it a 64 bit argument everywhere, which has
> > some other small disadvantages.
> 
> No, you can't.  32-bit systems can only pass 32-bit arguments.  If you're
> suggesting passing a pointer to a 64-bit argument instead, how's that any
> different from my suggestion of a separate parameter block?

I was thinking of splitting the 64 bit argument into two registers on
32 bit systems, like we do with other 64 bit input arguments (e.g. loff_t).
While there is not much of a difference, I'd always prefer passing
input arguments by register to a memory location when possible.

> > The idea of a syscall API with multiple fixed-length and variable-length
> > fields in the same structure scares me. If you want to go this far,
> > it may be better to base the interface on netlink and allow querying
> > multiple files at once.
> 
> Urgh.  Netlink is way too much overhead and even scarier.  That's pretty much
> a guarantee that people won't use it.  It also has to work if CONFIG_NET=n.

Exactly. Just resist the urge to add complexity bordering what we already
have in netlink.

	Arnd
