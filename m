From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4 file replace guarantees
Date: Thu, 20 Jun 2013 20:59:37 -0400
Message-ID: <20130621005937.GB10730@thunk.org>
References: <1371764058.18527.140661246414097.671B4999@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ryan Lortie <desrt@desrt.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59952 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965307Ab3FUA7l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Jun 2013 20:59:41 -0400
Content-Disposition: inline
In-Reply-To: <1371764058.18527.140661246414097.671B4999@webmail.messagingengine.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jun 20, 2013 at 05:34:18PM -0400, Ryan Lortie wrote:
> 
> in https://www.kernel.org/doc/Documentation/filesystems/ext4.txt
> 
> which says to me "replace by rename is guaranteed safe in modern ext4,
> under default mount options".

It's not _guaranteed_ safe.  It significantly reduces the chances of
data loss in case of a crash, but it's possible for the transaction
containing the rename to close before the blocks are written back.  So
if the transaction is almost full, or there is a fsync() racing with
the rename(), such that the file system operation to allocate the
delayed allocation blocks ends up in a different transaction than the
transaction where the rename took place (race #1), and then you crash
before the second transaction completes (race #2), you could lose
data.

You'll have to make your own decision about how likely this
combination is to happen.  The failure scenario would probably be
something like the user who plays tux racer all the time, and uses
crappy proprietary drivers that crash the system every single time an
OpenGL application exits.  If they think that's normal, and are
willing to live with the crap proprietary drivers, and they are also
the sort of people who carefully position all of their windows to be
precisely just so, and if the !@#!?! desktop libraries are still
bogusly rewriting the entire contents of every single registry file,
regardless of whether the application changed anything --- then
eventually, said user will whine about how the hours she spent
obsessively setting up their window layout got lost after Tux Racer
creashed their system *again*.

(Unfortunately, this example is not entirely hypothetical....)

Regards,

					- Ted
