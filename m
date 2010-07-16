From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended file stats available [ver #6]
Date: Fri, 16 Jul 2010 12:46:15 +0200
Message-ID: <201007161246.15923.arnd@arndb.de>
References: <201007152235.22373.arnd@arndb.de> <20100715021712.5544.44845.stgit@warthog.procyon.org.uk> <30646.1279230807@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <30646.1279230807-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Thursday 15 July 2010, David Howells wrote:
> Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> 
> > > This was initially proposed as a set of xattrs, but the general preferance
> > > is for an extended stat structure.
> > 
> > I don't think I'd call this general preference. Three of the four
> > are fixed length and could easily be done inside the structure if you
> > leave a bit of space instead of a variable-length field at the end.
> 
> ?
> 
> Maybe I wasn't clear: I meant having an extended stat() syscall rather than
> using a bunch of getxattr()'s was the general preference.

Ok, I misparsed your statement there. I don't think anyone was
objecting the use of xstat for this.

The controversial part is only how the extension happens. I would
already feel better about it if you just dropped the
'unsigned long long      st_extra_results[0];' at the end and
added a comment saying that the structure may grow in the future, though
my preference would be to space for extensions and make it fixed length.

> > For the volume id, I could not find any file system that requires more
> > than 32 bytes here, which is also reasonable to put into the structure.
> > Make it 36 if you want to cover ascii encoded UUIDs.
> 
> You should also include a length.  Volume IDs may be binary rather than
> NUL-terminated strings.

Yes, maybe. There are several possible encodings for this. I was actually
thinking of fixed-length string rather than zero-terminated, but that
is possible as well. If this gets added, we need to audit every possible
use to make sure each of them is covered. My point was mostly that if we
need at most 40 bytes, it doesn't have to be variable length at all.

> > That's at most 60 bytes for the extensions you're considering already,
> > plus the 152
> 
> 160, I think.

right.

> > you have already is still less than a cache line on
> > some machines. Padding it to 256 bytes would make it nice and round,
> > if you want to be really sure, make it 384 bytes.
> 
> Which we currently allocate on the kernel stack, plus up to a couple of kstat
> structs if something like eCryptFS is used.  Admittedly, the base xstat struct
> could be kmalloc()'d instead, but why use up all that space if you don't need
> it?

If you're worried about stack utilization, xstat could also be embedded into
kstat, like

struct kstat {
	u64 request_mask;
	struct xstat x;
};

Then you only need one of them on the stack for sys_xstat, or have both
struct kstat and struct stat/stat64 for the other syscalls.

	Arnd
