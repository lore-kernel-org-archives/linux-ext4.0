From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 01/10] Fs: ext4: acl.c: fixed indent issue
Date: Sun, 26 Sep 2010 15:17:05 -0700
Message-ID: <1285539425.1732.38.camel@Joe-Laptop>
References: <1285439521-2557-1-git-send-email-tdent48227@gmail.com>
	 <20100925233600.GA2854@lst.de>
	 <AANLkTimf9Q=jfga=--H0VaZeWnbAVNhCPMn_G81sZ8vh@mail.gmail.com>
	 <20100925235643.GA3224@lst.de> <1285459579.6115.72.camel@Joe-Laptop>
	 <20100926200611.GA4375@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: T Dent <tdent48227@gmail.com>, tytso@mit.edu,
	adilger.kernel@dilger.ca, jack@suse.cz, dmonakhov@openvz.org,
	sandeen@redhat.com, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>,
	Andrew Morton <akpm@linux-foundation.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100926200611.GA4375@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, 2010-09-26 at 22:06 +0200, Christoph Hellwig wrote:
> On Sat, Sep 25, 2010 at 05:06:19PM -0700, Joe Perches wrote:
> > On Sun, 2010-09-26 at 01:56 +0200, Christoph Hellwig wrote:
> > > On Sat, Sep 25, 2010 at 07:53:02PM -0400, T Dent wrote:
> > > > On 9/25/10, Christoph Hellwig <hch@lst.de> wrote:
> > > > > Please don't Cc me on ext4 patches, thanks.
> > > > Ok.. i just used the get maintainer script and your name was on it.
> > > The script is broken but the maintainer refuses to fix it.
> > That'd be false.
> > https://patchwork.kernel.org/patch/185352/
> Thanks for changing your opinion after the last discussion and fixing
> the worst fallout.  Can you please prod Andrew to sned it on to Linus
> ASAP?

I didn't change my mind.

I've never particularly liked the --git option
and rarely if ever use it.

What I said was I'd wait for a consensus.

Andrew generally doesn't like to forward stuff
to Linus unless it fixes some regression.  I
don't know if this qualifies.  Andrew?

I'd prefer to change the --rolestats default
to on as well and force scripts to include
--norolestats --noroles to get bare email
addresses.

cheers, Joe
