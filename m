From: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
Subject: Re: [Gluster-devel] regressions due to 64-bit ext4 directory cookies
Date: Wed, 13 Feb 2013 17:47:20 -0500
Message-ID: <20130213224720.GE5938@thunk.org>
References: <20130212202841.GC10267@fieldses.org>
 <20130213040003.GB2614@thunk.org>
 <20130213133131.GE14195@fieldses.org>
 <20130213151455.GB17431@thunk.org>
 <20130213151953.GJ14195@fieldses.org>
 <20130213153654.GC17431@thunk.org>
 <20130213162059.GL14195@fieldses.org>
 <CAFboF2wXvP+vttiff8iRE9rAgvV8UWGbFprgVp8p7kE43TU=PA@mail.gmail.com>
 <20130213222052.GD5938@thunk.org>
 <20130213224141.GU14195@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Anand Avati <anand.avati-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>,
	sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gluster-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
To: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130213224141.GU14195-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 13, 2013 at 05:41:41PM -0500, J. Bruce Fields wrote:
> > What if we have an ioctl or a process personality flag where a broken
> > application can tell the file system "I'm broken, please give me a
> > degraded telldir/seekdir cookie"?  That way we don't penalize programs
> > that are doing the right thing, while providing some accomodation for
> > programs who are abusing the telldir cookie.
> 
> Yeah, if there's a simple way to do that, maybe it would be worth it.

Doing this as an ioctl which gets called right after opendir, i.e
(ignoring error checking):

      DIR *dir = opendir("/foo/bar/baz");
      ioctl(dirfd(dir), EXT4_IOC_DEGRADED_READDIR, 1);
      ...

should be quite easy.  It would be a very ext3/4 specific thing,
though.

It would be more work to get something in as a process personality
flag, mostly due to the politics of assiging a bit out of the
bitfield.

						- Ted

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
