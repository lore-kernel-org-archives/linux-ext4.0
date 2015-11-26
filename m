From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] fix an endianness bug in ext4_encrypted_follow_link()
Date: Thu, 26 Nov 2015 14:47:56 -0800
Message-ID: <1448578076.18647.37.camel@perches.com>
References: <20151126152728.GT22011@ZenIV.linux.org.uk>
	 <1448566837.18647.16.camel@perches.com>
	 <20151126210223.GV22011@ZenIV.linux.org.uk>
	 <alpine.DEB.2.02.1511262227080.2034@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Julia Lawall <julia.lawall@lip6.fr>,
	Al Viro <viro@ZenIV.linux.org.uk>, lkp <lkp@intel.com>,
	Fengguang Wu <fengguang.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1511262227080.2034@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, 2015-11-26 at 22:28 +0100, Julia Lawall wrote:
> On Thu, 26 Nov 2015, Al Viro wrote:
> > On Thu, Nov 26, 2015 at 11:40:37AM -0800, Joe Perches wrote:
> > (cc'ing Julia Lawall)
> > > On Thu, 2015-11-26 at 15:27 +0000, Al Viro wrote:
> > > applying le32_to_cpu() to 16bit value is a bad idea...
> > Julia, perhaps you or your crew could produce a coccinelle test
> > for this class of error?
> What's wrong with something like make C=2 CF=-D__CHECK_ENDIAN__ fs/ext4/ ?
> Worked just fine, TYVM -
> sparse does locate them...

Nothing at all.

> As long as the code of interest is getting compiled in the current
> configuration, relying on the compiler for this seems like a better choice.

Sparse isn't the compiler, but that would be fine by me
as long as something can catch them.

The original commit (f348c252320b9) was from April.
Isn't the kbuild robot using sparse and __CHECK_ENDIAN__?
