From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [Gluster-devel] regressions due to 64-bit ext4 directory cookies
Date: Wed, 13 Feb 2013 18:05:11 -0500
Message-ID: <20130213230511.GW14195@fieldses.org>
References: <20130213133131.GE14195@fieldses.org>
 <20130213151455.GB17431@thunk.org>
 <20130213151953.GJ14195@fieldses.org>
 <20130213153654.GC17431@thunk.org>
 <20130213162059.GL14195@fieldses.org>
 <CAFboF2wXvP+vttiff8iRE9rAgvV8UWGbFprgVp8p7kE43TU=PA@mail.gmail.com>
 <20130213222052.GD5938@thunk.org>
 <20130213224141.GU14195@fieldses.org>
 <20130213224720.GE5938@thunk.org>
 <CAFboF2z1akN_edrY_fT915xfehfHGioA2M=PSHv0Fp3rD-5v5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
	Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>,
	sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gluster-devel-qX2TKyscuCcdnm+yROfE0A@public.gmane.org
To: Anand Avati <anand.avati-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFboF2z1akN_edrY_fT915xfehfHGioA2M=PSHv0Fp3rD-5v5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 13, 2013 at 02:57:13PM -0800, Anand Avati wrote:
> On Wed, Feb 13, 2013 at 2:47 PM, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org> wrote:
> 
> > On Wed, Feb 13, 2013 at 05:41:41PM -0500, J. Bruce Fields wrote:
> > > > What if we have an ioctl or a process personality flag where a broken
> > > > application can tell the file system "I'm broken, please give me a
> > > > degraded telldir/seekdir cookie"?  That way we don't penalize programs
> > > > that are doing the right thing, while providing some accomodation for
> > > > programs who are abusing the telldir cookie.
> > >
> > > Yeah, if there's a simple way to do that, maybe it would be worth it.
> >
> > Doing this as an ioctl which gets called right after opendir, i.e
> > (ignoring error checking):
> >
> >       DIR *dir = opendir("/foo/bar/baz");
> >       ioctl(dirfd(dir), EXT4_IOC_DEGRADED_READDIR, 1);
> >       ...
> >
> > should be quite easy.  It would be a very ext3/4 specific thing,
> > though.
> 
> 
> That would work, even though it would be ext3/4 specific. What is the
> recommended programmatic way to detect if the file is on ext3/4 -- we would
> not want to attempt that blindly on a non-ext3/4 FS as the numerical value
> of EXT4_IOC_DEGRADED_READDIR might get interpreted in dangerous ways?

We must have been through this before, but: is the only way to generate
a collision-free readdir cookie really to use a larger hash?

Would it be possible to make something work like, for example, a 31-bit
hash plus an offset into a hash bucket?

I have trouble thinking about this, partly because I can't remember
where to find the requirements for readdir on concurrently modified
directories....

--b.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
