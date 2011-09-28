From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [Xen-devel] Re: [patch 1/1]
 ext4-fix-dirty-extent-when-origin-leaf-extent-reac.patch
Date: Wed, 28 Sep 2011 15:46:44 -0400
Message-ID: <20110928194644.GC19250@thunk.org>
References: <BLU157-W499E698F650F554E645F9DDA1C0@phx.gbl>
 <20110906145347.GA4133@dumpdata.com>
 <BLU157-W4106FA4CF4EBA78C63FDA0DA1C0@phx.gbl>
 <4E666C86.5090707@goop.org>
 <BLU157-W323C330706CB8D7E976BC3DA1F0@phx.gbl>
 <BLU157-W7DABA5FE01C50C29B1A64DA060@phx.gbl>
 <BLU157-W25EB1EAC24CC11FA14859ADAF20@phx.gbl>
 <20110926142808.GG4102@phenom.oracle.com>
 <20110927193523.GB3309@thunk.org>
 <4E836A47.80107@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	MaoXiaoyun <tinnycloud@hotmail.com>, linux-ext4@vger.kernel.org,
	jack@suse.cz, xen devel <xen-devel@lists.xensource.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40935 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752058Ab1I1Tqv (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 28 Sep 2011 15:46:51 -0400
Content-Disposition: inline
In-Reply-To: <4E836A47.80107@goop.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 28, 2011 at 11:41:11AM -0700, Jeremy Fitzhardinge wrote:
> Since kernel.org 2.6.32 is still considered to be a maintained
> long-term-stable kernel, I keep the xen.git version up-to-date with
> stable-2.6.32 bugfixes and occasional separate Xen-specific fixes.  But
> I'd really prefer to avoid having any non-Xen private changes in that
> tree, in favour of getting everything from upstream stable.
> 
> Do you not consider it worth continuing support of the 2.6.32 stable
> tree with respect to ext4?

I just don't have the *time* to maintain backports of ext4 fixes to
2.6.32.  There have been so many bug fixes to ext4, and some of them
depend on changes in the quota subsystem, so trying to back port them
all would be hellish, and not something I'm willing to do on a
volunteer basis.

I'm busy enough with silly things like trying to help with the
kernel.org getting back on-line, that channelling my stay-really-late
hours to support users who are too cheap to pay distro support fees is
not really a way that I would choose to spend my personal time.

If someone would like to volunteer to be unpaid distro support, that's
great.  It's worth it as long as I get to volunteer somebody else's
time.  :-)

					- Ted

