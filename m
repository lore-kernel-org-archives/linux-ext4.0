From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 3/3] Add a pair of system calls to make extended file stats available [ver #2]
Date: Wed, 30 Jun 2010 13:46:41 +0200
Message-ID: <201006301346.41902.arnd@arndb.de>
References: <201006301131.37241.arnd@arndb.de> <25470.1277888151@redhat.com> <29346.1277892068@redhat.com>
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
In-Reply-To: <29346.1277892068-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wednesday 30 June 2010, David Howells wrote:
> Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> > No, I think that would be worse than the current version. But if you remove
> > the structure version in favor of the flags, you only need six arguments
> > anyway.
> 
> I want to keep the structure version, just in case we need to expand fields in
> the stat struct in future.  Otherwise we may need to create yet another stat
> syscall.

How many versions do you expect we need in the next 10 years, not counting
those where you just add a new field to the structure?

Given a 64 bit flag word, you can start using bits for the version from
the top and bits from the bottom for fields:

#define XSTAT_DEV  0x00000001
#define XSTAT_INO  0x00000002
#define XSTAT_MODE 0x00000004
...
#define XSTAT_LAYOUT_VERSION_2 0x8000000000000000
#define XSTAT_LAYOUT_VERSION_1 0x0000000000000000

> > You can also go further and fold the structure length into flags, because
> > the length is just a function of the data you are passing.
> 
> The potential problem with passing the flags as a syscall argument is that
> we're then limited to a single 32-bit integer.  It might be enough, but if I
> do as at least one person has suggested and assign each field in the struct
> its own bit, that uses up half right there, plus I'd like to add at least one
> operational flag (to force synchronisation with the server).

I'd imagine that there would be some reasonable way to group some of the
fields so that 32 bits last long enough. Alternatively, you can also make
it a 64 bit argument everywhere, which has some other small disadvantages.

> > Having a system call with flags, size and version is like wearing a belt,
> > braces and suspenders. An unsigned long flags argument should be enough to
> > hold up your pants[1].
> 
> I would like the size argument for two reasons: firstly, to prevent buffer
> overruns and, secondly, because I can see some scope for variable-size fields
> (such as for volume IDs or security labels), though the latter might be better
> handled through getxattr() (which would mean extra overhead).

The idea of a syscall API with multiple fixed-length and variable-length
fields in the same structure scares me. If you want to go this far,
it may be better to base the interface on netlink and allow querying
multiple files at once.

For a classic syscall interface, I'd just stay away from variable-length
data and use either fixed-length fields or spend the extra overhead for
the getxattr values.

When all members of struct xstat are fixed length, you can simply add
new members at the end and add the associated flags at the same time.
Any code built against a given header file can only ask for the fields
that are part of the struct definition it uses. The kernel should
obviously only write the fields that the user asked for, in case the
user was built against an older header file. You can also maintain
forward compatibility if the kernel sets a bitmask in the struct with
the fields it has returned.

	Arnd
