From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: EXT4-fs error w/ external USB drive
Date: Wed, 24 Oct 2012 14:35:05 -0400
Message-ID: <20121024183505.GA6142@thunk.org>
References: <507C4BDA.20205@gmx.de>
 <20121019210723.GA4721@thunk.org>
 <5085923F.9050801@gmx.de>
 <20121024011128.GG28626@thunk.org>
 <5088260D.7080403@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5088260D.7080403@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Oct 24, 2012 at 07:31:57PM +0200, Toralf F=F6rster wrote:
> > Are you using any kind of special mount options on your usb stick?
> >
> nope

Thanks, we're trying to get a reliable repro of this failure, and so
every bit of data helps...  I've cc'ed you on the other thread, and if
you could try the second patch I sent out last night (and let me know
when/if the WARN_ON triggers), I'd really appreciate it.

Thanks again,

                                          - Ted
