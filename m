From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: same ext4 file system corruption on different machines
Date: Thu, 30 Jan 2014 22:00:28 -0500
Message-ID: <20140131030028.GB7118@thunk.org>
References: <1390999955.2601.22.camel@snow.station>
 <1391000743.2601.26.camel@snow.station>
 <20140129173826.GA30419@thunk.org>
 <1391068749.2680.6.camel@snow.station>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Luca Ognibene <luca.ognibene@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1391068749.2680.6.camel@snow.station>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jan 30, 2014 at 08:59:09AM +0100, Luca Ognibene wrote:
> Yes it's indeed very strange.. i tend to rule out application errors
> because i don't write directly to the device so i don't think i can
> break a filesystem from userspace. I've checked previous and next blocks
> and they seem ok, only the block 524320 is getting corrupted. Any idea
> on what should i look for now?

Are you willing to try 3.12.9 or 3.13.1 upstream kernel?  Let's see if
changing the kernel makes any difference.  I don't recall any ext4
problems like this, but maybe it's device driver problem.

The other thing I'd ask is whether you can swap out the hard drive
interface --- can you use a USB 3.0 attached drive, or something like
that?

One final thing that you could try doing, depending on how
easily/quickly you can reproduce the problem, is to use blktrace and
see if you can catch who or what is writing to that specific block
which is getting corrupted.

						- Ted
