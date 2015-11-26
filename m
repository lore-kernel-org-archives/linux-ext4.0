From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 02/12] statx: Provide IOC flags for Windows fs attributes
Date: Thu, 26 Nov 2015 16:01:23 +0000
Message-ID: <22523.1448553683@warthog.procyon.org.uk>
References: <7976.1448552129@warthog.procyon.org.uk> <20151124195256.GB3482@thunk.org> <20151120145422.18930.72662.stgit@warthog.procyon.org.uk> <20151120145447.18930.5308.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, linux-afs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7976.1448552129-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Content-ID: <22522.1448553683.1-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> > As a result, I would suggest that we not try to use the
> > FS_IOC_[GS]ETFLAGS number scheme for any new interface, so we're at
> > least not making a bad situation worse.
> > 
> > The only reason why some other file systems have chosen to use
> > FS_IOC_[GS]ETFLAGS, instead of defining their own ioctl, is so they
> > can use lsattr/chattr from e2fsprogs instead of creating their own
> > utility.  But for statx, there isn't a good reason use the same flags
> > number space.  At the very least, can we use a new flags field for the
> > Windows file attributes?  It's not like lsattr/chattr has the ability
> > to set those flags today anyway.  So we might as well use a new flags
> > field and a new flags numberspace for them.
> 
> Hmmm...  I was trying to make it so that these bits would be saved to disk as
> part of the IOC flags so that Samba could make use of them.  I guess they'll
> have to be stored in an xattr instead.

Or as Dave Chinner suggested, I can put them elsewhere and let the FS deal
with them in its own way.

David
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
