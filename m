From: "Kay Sievers" <kay.sievers-tD+1rO4QERM@public.gmane.org>
Subject: Re: [PATCH, RFC] add fsck to util-linux
Date: Wed, 26 Sep 2007 14:29:30 +0200
Message-ID: <3ae72650709260529p7c4a7d9cq4d490a6d6706814b@mail.gmail.com>
References: <20070925153735.GA26693@infradead.org>
	 <20070926105946.GB429@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Christoph Hellwig" <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	util-linux-ng-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Theodore Tso" <tytso-3s7WtUTddSA@public.gmane.org>
Return-path: <util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20070926105946.GB429-AKGzg7BKzIDYtjvyW6yDsg@public.gmane.org>
Content-Disposition: inline
Sender: util-linux-ng-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On 9/26/07, Theodore Tso <tytso-3s7WtUTddSA@public.gmane.org> wrote:
> On Tue, Sep 25, 2007 at 04:37:35PM +0100, Christoph Hellwig wrote:
> > This adds fsck from latest e2fsprogs git to util-linux.  There are only
> > tiny changes to integrate it into the build system and nls setup of
> > util-linux and fixing up the trailing whitespaces quilt is complaining
> > about.  I've not yet converted it to the fsprobe helpers as the discussion
> > on those libs is still ongoing and I haven't read up on the fsprobe library
> > either.
>
> It looks like you pulled fsck from the master branch of e2fsprogs git;
> there is one slight bug fix in the maint branch that hasn't been
> merged into master yet, commit ed773a263829493e4e4bf612dbec2380cf09349f:
>
>     fsck: Ignore /etc/fstab entries for bind mounts
>
>     If a user specifies a bind mount with a non-zero fsck pass number, for
>     example:
>
>     /foo    /bar    ext3    bind,defaults   1 3
>
>     print a warning and ignore the fstab entry.
>
>     Addresses-Red-Hat-Bugzilla: #151533
>
>     Signed-off-by: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     Signed-off-by: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
>
> BTW, I don't like this syntax in the fstab file AT ALL, but it is in
> use in the wild by at least some Fedora users, and it's not documented
> in the fstab man page.  I'd suggest using a filesystem type of bind,
> rather than ext3, as the officially "blessed" way of specifying it in
> fstab, but it badly needs to be documented in the fstab and/or mount
> man pages.  The above patch should probably get included, though, and
> backwards compatibility for allowing "bind" to be specified in the
> mount options, and with a warning message that the specifying "bind"
> in the options field has been deprecated.
>
> So with the above patch included,
>
> Acked-by: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
>
> For future code movement, I don't mind fsck moving over, but I would
> like to manage moving over blkid to util-linux-ng myself, as I have
> some pretty strong feelings about the right way to do things.  I am
> quite willing to add some low-level interfaces so that fsid can use
> the same fs probing logic, and I'm willing to add some code so that
> the high-level interfaces of libblkid, if the /dev/disk/by-* links are
> present and the user isn't asking for information which isn't in the
> blkid cache, will use the symlinks instead.  However, I really don't
> want to encode a dependency on udev being there, and I think it should
> be possible to make the fallback be transparent instead of being a
> compile-time option.

I really don't want to see something like: "the user isn't asking for
information which isn't in the blkid cache" thing near the code udev
has to call. The cache must be part of the "high-level" blkid
functions, and nothing like this should come near the plain probing
functions.
The compile-time udev switch and the udev symlink logic is already in
the util-linux fsprobe  wrapper, and there is no need to move that
into blkid now, especially not by trying to make anything
"transparent".

The low-level functions need to handle 64bit probing offset and size
values, so we can probe partitioned devices.

We also need all filesytem types, all raid metadata probing, and
filesystem version  number and classification information in the final
library, so that udev is able to switch over.

A low-level probe must be able to return:
   the classification (filesystem, other, raid, crypto)
   the filesystem name string (ext3, vfat, xfs, ...)
   the version of the filesystem (1.3, FAT32, 0.9, ...)
   a label string (unicode validated and translated to utf8)
   the raw bytes and the length of the label
   a UUID string (some raid sets have free-text UUID's today)
   the raw UUID string and the length

And we need to be able to call the sets of raid probing and filesystem
probing functions independent from each other, so that we are able to
skip all raid probing.

I like to see the ~40 volume_id filesystem/raid probing files merged,
and the content of probe.c replaced with calls to these files, while
preserving the current probing order of blkid.

Thanks,
Kay
