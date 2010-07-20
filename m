From: Andreas Dilger <adilger-m1MBpc4rdrD3fQ9qLvQP4Q@public.gmane.org>
Subject: Re: [PATCH 02/18] xstat: Add a pair of system calls to make extended file stats available [ver #6]
Date: Tue, 20 Jul 2010 02:28:25 -0600
Message-ID: <4161BF3D-D410-4AEC-8185-975203182B94@dilger.ca>
References: <20100715021709.5544.64506.stgit@warthog.procyon.org.uk> <20100715021712.5544.44845.stgit@warthog.procyon.org.uk> <AANLkTikuzYqYpGHcubb7QVciZW0dNFjOG82qIwy5M4gO@mail.gmail.com> <10783.1279556132@redhat.com> <AANLkTinVns77R7yCCh-lydd0eQufdAF9O2OaWmCL7uSn@mail.gmail.com> <11817.1279560400@redhat.com> <AANLkTikxHJgguNn6EOK6fX53xYSRPmcNjIeGSTigQ9qu@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikxHJgguNn6EOK6fX53xYSRPmcNjIeGSTigQ9qu-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 2010-07-19, at 11:46, Linus Torvalds wrote:
> On Mon, Jul 19, 2010 at 10:26 AM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> I suspect they would, though maybe they can say otherwise.  What about SMB
>> directory enumeration?  I believe that is effectively getdents-with-stat.
>> Having to do open+stat for each file for that would be painful.
> 
> Yeah, but do you need xstat information at all for something like
> that? Most people try very hard to make do with the information
> returned by readdir itself (d_type and inode number), because if you
> end up looking up each name you've already pretty much lost in a
> performance model.

This lightweight stat() interface is exactly needed for things like "color ls",
which is the default on all distros today.  "ls --color" always does a stat on the file just to get the file mode to color executable files differently.  For Lustre and other distributed filesystems, getting things like the current file size is hard work (i.e. multiple RPCs per file), yet "ls" doesn't care about the size or modification times unless "ls -l" is used.  Same goes for "find".

> (And I do agree that a "readdirplus()" is probably something that a
> lot of server people would find useful, but obviously that's another
> cross-filesystem nightmare. Only a few filesystems can cheaply give
> you anything but d_type/d_ino, and not all do even that),

Having a readdirplus() syscall would be even better, but again only with the ability to request specific attributes.  Otherwise the filesystem may be doing a lot of extra work to collect all of the file attributes, and then userspace will probably be throwing most of them away.

Cheers, Andreas





--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
