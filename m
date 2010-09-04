From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 2/3] lib: improve the performance of memcpy and memmove
 of the general version
Date: Sat, 4 Sep 2010 15:41:14 +0100
Message-ID: <20100904154114.19501d6e@lxorguk.ukuu.org.uk>
References: <4C7E2CAC.6080102@cn.fujitsu.com>
	<82mxrzrsvq.fsf@mid.bfk.de>
	<1283605142.9039.4.camel@ayu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Florian Weimer <fweimer@bfk.de>, miaox@cn.fujitsu.com,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Mason <chris.mason@oracle.com>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: Calvin Walton <calvin.walton@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39398 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752781Ab0IDOW7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 Sep 2010 10:22:59 -0400
In-Reply-To: <1283605142.9039.4.camel@ayu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 04 Sep 2010 08:59:02 -0400
Calvin Walton <calvin.walton@gmail.com> wrote:

> On Fri, 2010-09-03 at 11:03 +0000, Florian Weimer wrote:
> > * Miao Xie:
> > 
> > >  EXPORT_SYMBOL(memcpy);
> > 
> > I think you need to change that to EXPORT_SYMBOL_GPL, because the code
> > is now licensed under the GPL, and not the GPL plus kernel exceptions
> > (whatever they are, but they undoubtly exist), unlike the original
> > implementation.
> 
> I wouldn't think so - the intent of EXPORT_SYMBOL_GPL is to mark symbols
> that make it obvious that a module was derived from the Linux kernel, as
> opposed to some sort of generic driver that was just ported to a new
> interface. (It's not foolproof, it's more of a warning to developers.)

EXPORT_SYMBOL_GPL was meant for symbols that were clearly internal
workings. EXPORT_SYMBOL() doesn't in any way imply or excuse GPL
compliance for any derivative work.

Using the FSF memcpy seems a good technical idea, and it'll no doubt
liven up the proprietary module makers lawyers as it'll make the FSF a
party to any infringement disputes 8)

Alan
