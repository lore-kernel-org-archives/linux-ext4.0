From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 file replace guarantees
Date: Sat, 22 Jun 2013 10:30:53 -0400
Message-ID: <20130622143053.GF4727@thunk.org>
References: <1371764058.18527.140661246414097.671B4999@webmail.messagingengine.com>
 <20130621005937.GB10730@thunk.org>
 <1371818596.20553.140661246775057.0F7160F3@webmail.messagingengine.com>
 <20130621131521.GE10730@thunk.org>
 <1371822707.3188.140661246795017.2D10645B@webmail.messagingengine.com>
 <bf675d01f2290be4e38f602ce78643c9@josephdwagner.info>
 <20130621210556.GB10582@thunk.org>
 <C0F0BC787567C848B2C90989451123DA2363CAFF@ATLEXMBX4.ARRS.ARRISI.com>
 <20130622125604.GD4727@thunk.org>
 <C0F0BC787567C848B2C90989451123DA2363CBCC@ATLEXMBX4.ARRS.ARRISI.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Joseph D. Wagner" <joe@josephdwagner.info>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ryan Lortie <desrt@desrt.ca>
To: "Sidorov, Andrei" <Andrei.Sidorov@arrisi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60271 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920Ab3FVOa6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 22 Jun 2013 10:30:58 -0400
Content-Disposition: inline
In-Reply-To: <C0F0BC787567C848B2C90989451123DA2363CBCC@ATLEXMBX4.ARRS.ARRISI.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Jun 22, 2013 at 02:01:39PM +0000, Sidorov, Andrei wrote:
> 
> This doesn't work in power loss scenario.
> First of all majority of hdd's still have 512b sectors, so it is possible that
> hdd won't have a chance to write all 8 sectors.
> This doesn't work even with 4k drives because they are susceptible to spliced
> sector writes. Well, 512b are susceptible too, but 4k drives have wider
> window.

Torn writes can happen, yes, but they are relatively rare.  Most file
systems don't protect against them, so if you're worried about that
sort of thing, you need to go beyond using fsync().  Even if you are
using a file system with metadata journalling, in the case of a torn
write, we'll detect the corrupt metadata, but at that point guarantees
about what files will be accessible are out the window.  Fortunately,
this is not a common event.

There are techniques for protecting against torn writes, but they have
engineering tradeoffs, which you may or may not be willing to live
with.  After all, if you're worried about these sorts of things,
hopefully you will have engineered your system to deal with other
events which are at the a similar or higher levels of probability ---
such as the hard drive developing bad sectors (which is generally how
most HDD's treat sectors that are incompletely written due to spliced
sector writes) or even dying catastrophically.

For many of the use cases that Ryan and GNOME have been dealing with,
which are desktop apps where the precious data at question are things
like the high score board for games, or the window position of desktop
applications, this is probably beyond what they need to be concerned
with.

(And at the industrial data center scale, you may use very different
techniques --- such as computer-level or rack-level battery backups,
diesel generators, cloud file systems which send the data to multiple
different servers on multiple different racks, etc.  And at that
scale, you might not even use a file system journal or send CACHE
FLUSH commands, because you've engineered the entire system against
failure, and you accept the fact that having multiple levels of power
backup fails, or multiple HDD's all dying at the same time before the
cloud file system has a chance to rereplicate the data, is good
enough. Nothing is ever going to be 100% perfect; there's only a level
of data integrity which you are willing to pay for.)

						- Ted
