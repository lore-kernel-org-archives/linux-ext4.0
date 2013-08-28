From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Unable to randomly boot rootfs (EXT3 or EXT4) from SD: MMC error
 -110 (TIMEDOUT)
Date: Wed, 28 Aug 2013 13:56:22 -0400
Message-ID: <20130828175622.GA27079@thunk.org>
References: <CAL1yNcJZBSSNu4aDmL6n9uu3LkNPCOM-LbUXD2990jkPJYpLoA@mail.gmail.com>
 <CAL1yNc+9pOWLCLfk7WpWvvsLfb01cFCJSi+4mTvnks9VrwoF1Q@mail.gmail.com>
 <20130827220143.GC9182@thunk.org>
 <CAL1yNcLzXir7KFavxaQK3OWWU5hHc06tvOSLrdvWB-VoEJdXQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-ext4@vger.kernel.org, arnd@linaro.org
To: Kevyn-Alexandre =?iso-8859-1?Q?Par=E9?=
	<kevyn.alexandre.pare@gmail.com>
Return-path: <linux-mmc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAL1yNcLzXir7KFavxaQK3OWWU5hHc06tvOSLrdvWB-VoEJdXQA@mail.gmail.com>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Aug 28, 2013 at 11:22:58AM -0400, Kevyn-Alexandre Par=E9 wrote:
> We try multiple of our system ( Different micro SD from SanDisk +
> Overo with OMAP3) and they are all doing this with the SanDisk 64GB,
> 32GB :
> http://www.sandisk.com/products/memory-cards/microsd/ultra-class10-fo=
r-android/?capacity=3D64GB
>=20
> The problem seem to be easier to reproduce when we just flash the
> micro SD (partition, format & copy rootfs) at it first boot.
> Also, when we let the system down for a couple of days and then
> sometimes we need to reboot the system multiple times before it fall
> back alright.
>=20
> We found a old patch that was simply increasing the timeout of the ho=
st:
> http://cgit.openembedded.org/cgit.cgi/openembedded/tree/recipes/linux=
/linux-omap-2.6.39/sakoman/0024-omap-mmc-Adjust-dto-to-eliminate-timeou=
t-errors.patch?h=3Dorg.openembedded.dev
>=20
> By settings the timeout to zero I reproduce kind of the same timeout
> error at every boot. That was expected since I don't let enough time
> to the controller to respond...
>=20
> Could the mix of that MMC controller and these card is not optimal? I=
s
> the driver fully supporting the UHS-I speed grade?

I've cc'ed Arnd Bergman who works at Linaro; I suspect that if he
doesn't know the answer off the top of his head, he can probably
direct you to someone who will.

							- Ted
