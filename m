From: =?ISO-8859-1?Q?Kevyn=2DAlexandre_Par=E9?=
	<kevyn.alexandre.pare@gmail.com>
Subject: Re: Unable to randomly boot rootfs (EXT3 or EXT4) from SD: MMC error
 -110 (TIMEDOUT)
Date: Wed, 28 Aug 2013 11:22:58 -0400
Message-ID: <CAL1yNcLzXir7KFavxaQK3OWWU5hHc06tvOSLrdvWB-VoEJdXQA@mail.gmail.com>
References: <CAL1yNcJZBSSNu4aDmL6n9uu3LkNPCOM-LbUXD2990jkPJYpLoA@mail.gmail.com>
	<CAL1yNc+9pOWLCLfk7WpWvvsLfb01cFCJSi+4mTvnks9VrwoF1Q@mail.gmail.com>
	<20130827220143.GC9182@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-mmc-owner@vger.kernel.org>
In-Reply-To: <20130827220143.GC9182@thunk.org>
Sender: linux-mmc-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi Ted,

On Tue, Aug 27, 2013 at 6:01 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Tue, Aug 27, 2013 at 05:47:22PM -0400, Kevyn-Alexandre Par=E9 wrot=
e:
>> mmcblk0: error -110 sending status command, retrying
>> mmcblk0: error -110 sending status command, retrying
>> mmcblk0: error -110 sending status command, aborting
>
> This looks like a hardware problem; either with the MMC reader, or th=
e
> MMC/SD card.

That's what I thought, thanks.

>
> Can you try swapping out the hardware and see if the problem goes
> away?

We try multiple of our system ( Different micro SD from SanDisk +
Overo with OMAP3) and they are all doing this with the SanDisk 64GB,
32GB :
http://www.sandisk.com/products/memory-cards/microsd/ultra-class10-for-=
android/?capacity=3D64GB

The problem seem to be easier to reproduce when we just flash the
micro SD (partition, format & copy rootfs) at it first boot.
Also, when we let the system down for a couple of days and then
sometimes we need to reboot the system multiple times before it fall
back alright.

We found a old patch that was simply increasing the timeout of the host=
:
http://cgit.openembedded.org/cgit.cgi/openembedded/tree/recipes/linux/l=
inux-omap-2.6.39/sakoman/0024-omap-mmc-Adjust-dto-to-eliminate-timeout-=
errors.patch?h=3Dorg.openembedded.dev

By settings the timeout to zero I reproduce kind of the same timeout
error at every boot. That was expected since I don't let enough time
to the controller to respond...

Could the mix of that MMC controller and these card is not optimal? Is
the driver fully supporting the UHS-I speed grade?

Regards,

-KA

>
>                                                 - Ted
