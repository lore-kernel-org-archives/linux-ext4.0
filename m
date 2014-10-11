From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: CF Card wear optimalisation for ext4
Date: Sat, 11 Oct 2014 19:19:48 -0400
Message-ID: <20141011231948.GC6262@thunk.org>
References: <5435661D.2040905@powercraft.nl>
 <08F28BC7-34FD-46BA-9D91-CC7D57A4A4D5@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jelle de Jong <jelledejong@powercraft.nl>,
	EXT3 Users <ext3-users@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48008 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaJKXT4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 11 Oct 2014 19:19:56 -0400
Content-Disposition: inline
In-Reply-To: <08F28BC7-34FD-46BA-9D91-CC7D57A4A4D5@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Something else that you might want to do is count the number of
journal commits that are taking place, via a command like this:

perf stat -e jbd2:jbd2_start_commit -a sleep 3600

This will count the number of jbd2 commits are executed in 3600
seconds --- i.e., an hour.

If you are running some workload which is constantly calling fsync(2),
that will be forcing journal commits, and those turn into cache flush
commands that force all state to stable storage.  Now, if you are
using CF cards that aren't guaranteed to have power-loss protection
(hint: even most consumer grade SSD's do not have power loss
protection --- you have to pay $$$ for enterprise-grade SLC SSD's to
have power loss protection --- and I'm guessing most CF cards are so
cheap that they won't make guarantees that all of their flash metadata
are saved to stable store on a power loss event) the fact that you are
constantly using fsync(2) may not be providing you with the protection
you want after a power loss event.

Which might not be a problem if you have a handset with a
non-removable eMMC device and a non-removable battery that can't fly
out when you drop the phone, but for devices which which can easily
have unplanned power failure, it may every well be the case that
you're going to be badly burned across a power fail event anyway.

So the next question I would ask you is whether you care about
unplanned power failures.  If so, you probably want to test your CF
cards to make sure they actually will do the right thing across a
power failure --- and if they don't, you may need to replace your CF card provider.

If you don't care (because you don't have a removable battery, and the
CF card is permanently sealed inside your device, for example), then
you might want to consider disabling barriers so you're no longer
forcing synchronous cache flush commands to be sent to your CF card.
This trades off power failure safety versus increased performance and
decreased card wear --- but if you don't need power failure safety,
then it might be a good tradeoff.

And if you *do* need power fail protection, then it's a good thing to
test whether your hardware will actually provide it, so you don't find
out the hard way that you're paying the cost of decreased performance
and increased card wear, but you didn't get power fail protection
*anyway* because of hardware limitations.

Cheers,

					- Ted
