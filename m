From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/3] ext4: Context support
Date: Tue, 12 Jun 2012 08:32:17 -0400
Message-ID: <20120612123217.GB7288@thunk.org>
References: <1339411562-17100-1-git-send-email-saugata.das@stericsson.com>
 <1339411562-17100-2-git-send-email-saugata.das@stericsson.com>
 <1339414891.2401.12.camel@sauron.fi.intel.com>
 <20120611122736.GA14051@thunk.org>
 <CAKLKtzeo1x+0Kxd0+29yqvXh4FBiS+p=T7b1-BWb6HXH5e1hhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
	Saugata Das <saugata.das@stericsson.com>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mmc@vger.kernel.org, patches@linaro.org, venkat@linaro.org,
	Arnd Bergmann <arnd.bergmann@linaro.org>
To: Saugata Das <saugata.das@linaro.org>
Return-path: <linux-mmc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKLKtzeo1x+0Kxd0+29yqvXh4FBiS+p=T7b1-BWb6HXH5e1hhQ@mail.gmail.com>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 12, 2012 at 05:51:22PM +0530, Saugata Das wrote:
> > The proof-of-concept patches seem to use the inode number as a way =
of
> > trying to group related writes, but what about at a larger level th=
an
> > that? =A0For example, if we install a RPM or deb package where all =
of
> > the files will likely be replaced together, should that be given th=
e
> > same context?
>=20
> In this patch, context is used at file level based on inode number.
> So, in the above example, multiple contexts will be used for the
> directory, file updates during RPM installation.

Yes --- I was trying to explore if we should try to do better than
that.  For example, it would probably be a good idea (at minimum) to
hash some kind of partition id into the inode number to form the
context id.  It's probably rare that a MMC card would be partitioned,
but it might be much more common for other flash devices.

I could also imagine schemes where via some fcntl, additional file
descriptors could be joined to the context of another file descriptor.
Or maybe we have a scheme whereby some high-level, abstract, context
id's could be generated, and assigned to a group of file descriptors.

A hueristic where all file creations that occur within close together
in time are considered to be related might work well for the package
installation case, but might break down in others.  Which is why I
asked the question of what is the downside if the hueristics screw up,
and occasionally group together files/blocks that aren't related with
respect to when they are deallocated (since that *is* what the flash
devices care about, right?)

						- Ted
