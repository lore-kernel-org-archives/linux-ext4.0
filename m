From: Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH] [Coding Style]: fs/ext{3,4}/ext{3,4}_jbd{,2}.c
Date: Fri, 11 Jan 2008 19:29:30 +0900
Message-ID: <20080111102930.GA31581@linux-sh.org>
References: <1199452896-20145-3-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-4-git-send-email-mathieu.segaud@regala.cx> <1199452896-20145-5-git-send-email-mathieu.segaud@regala.cx> <477E379F.4000103@student.ltu.se> <20080105041228.GP3351@webber.adilger.int> <20080105051817.GD27894@ZenIV.linux.org.uk> <4786883E.30604@tiscali.nl> <20080111030945.27954.qmail@cdy.org> <20080111034240.GA29861@linux-sh.org> <47873ABA.5050604@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
	Mathieu Segaud <mathieu.segaud@regala.cx>,
	Richard Knutsson <ricknu-0@student.ltu.se>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux-ext4@vger.kernel.org
To: Roel Kluin <12o3l@tiscali.nl>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from pip10.gyao.ne.jp ([61.122.117.248]:31255 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755954AbYAKKaE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 11 Jan 2008 05:30:04 -0500
Content-Disposition: inline
In-Reply-To: <47873ABA.5050604@tiscali.nl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jan 11, 2008 at 10:45:30AM +0100, Roel Kluin wrote:
> Paul Mundt wrote:
> > On Fri, Jan 11, 2008 at 04:09:45AM +0100, Peter Stuge wrote:
> >> On Thu, Jan 10, 2008 at 10:03:58PM +0100, Roel Kluin wrote:
> >>> -#define DEBUG(x,args...)	printk(__FUNCTION__ ": " x,##args)
> >>> +#define DEBUG(x, args...)	printk("%s: ", __func__, x, ##args)
> >> Can this really be expected to work when x contains conversions?
> >>
> >> How about:
> >>
> >> #define DEBUG(x, args...) printk("%s: " x, __func__, ##args)
> >>
> > How about throwing out hand-rolled debug printk wrappers for the
> > brain-damage they are and using the ones the kernel provides instead?
> > 
> Should it be done like this?
> --
> Replace printk wrapper - with a syntax error - by pr_debug
> 
> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>

Close. But in this case #define DEBUG is already instrumented by the
subsystem-wide debug option if it's enabled, so it's preferable to use
that and just drop the special debug Kconfig option completely.

Take a look at how CONFIG_PCMCIA_DEBUG is handled.

With DEBUG()->pr_debug() conversion here you've silently dropped the
__func__ prefixing. Note that dev_dbg() is usually preferred when you can
get a hold of a struct device pointer, as it takes care of prettifying
the output with the driver name and so on, rather than the convention of
adding a prefix. If you can't get at the struct device pointer, you'll
probably just want to insert the __func__ prefixing manually at the
callsites.
