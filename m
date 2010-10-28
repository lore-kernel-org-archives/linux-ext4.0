From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [next-20101038] Call trace in ext4
Date: Thu, 28 Oct 2010 16:37:06 -0400
Message-ID: <20101028203706.GD28126@thunk.org>
References: <AANLkTi=E_uMj_ndGU86DCjX4aDwjHqg3dkwxjQRSJtq6@mail.gmail.com>
 <20101028175221.GA1578@arch.trippelsdorf.de>
 <20101028180118.GC6814@thunk.org>
 <20101028193211.GA28126@thunk.org>
 <AANLkTimHJe9bA-X+JWkspgjb4AZkkgbEFWQiwzO-gx-h@mail.gmail.com>
 <20101028200548.GC28126@thunk.org>
 <AANLkTimw9Vwzy4MXO1t7TnJfwTwYtWcfj0D=Zx8O72cY@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
	LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
	sfr@canb.auug.org.au, Arnd Bergmann <arnd@arndb.de>,
	Avinash Kurup <kurup.avinash@gmail.com>
To: sedat.dilek@gmail.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:48532 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934192Ab0J1UhO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 28 Oct 2010 16:37:14 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTimw9Vwzy4MXO1t7TnJfwTwYtWcfj0D=Zx8O72cY@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 28, 2010 at 10:15:00PM +0200, Sedat Dilek wrote:
> 
> I created a new ext4.ko via "make M=fs/ext4" in the build-dir and
> copied the the kernel-module to /lib/modules/$(uname
> -r)/kernel/fs/ext4/, is that not enough?

It might not be.  Some distributions include modules in the initial
ramdisk, and load the module from the initrd, simply dropping the
module in /lib/modules/<kver>/... might not be enough.  So recreating
the initrd and then rebooting might be enough.

Certainly if you drop it there on a running kernel, if you don't
unload the module (before unmounting all of your ext4 file systems),
and then reload the module, *definitely* just copying a module into
/lib/modules.... without making sure the module is reloaded, you'll
still have the old module.

						- Ted
