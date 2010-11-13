From: Ted Ts'o <tytso@mit.edu>
Subject: Re: 2.6.36: kernel panic in cascade (Fatal exception in interrupt)
Date: Sat, 13 Nov 2010 18:33:53 -0500
Message-ID: <20101113233353.GB18658@thunk.org>
References: <201011032334.30662.thomas@m3y3r.de>
 <201011080014.33354.thomas@m3y3r.de>
 <alpine.LFD.2.00.1011081047500.2900@localhost6.localdomain6>
 <1289242528.11571.8.camel@localhost.localdomain>
 <alpine.LFD.2.00.1011082039360.2900@localhost6.localdomain6>
 <1289418184.6530.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-ext4@vger.kernel.org
To: Thomas Meyer <thomas@m3y3r.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1289418184.6530.6.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 10, 2010 at 08:43:04PM +0100, Thomas Meyer wrote:
> > 
> > I leave it to the ext4 experts to solve it for real :)
> > 
> 
> I just booted into 2.6.37-rc1-00166-g814ce25 and I don't see above bug
> in this kernel. So it seems as this bug got fixed in between 2.6.36 and
> 2.6.37-rc1+

Yes, this was fixed in 2.6.37-rc1 in commit: a1c6c5698d53 (ext4: fix
NULL pointer dereference in print_daily_error_info()).  I'll put it on
my list of things to be backported to 2.6.36.

					- Ted
