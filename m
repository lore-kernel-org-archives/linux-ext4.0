From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Mon, 24 Aug 2009 20:08:42 -0400
Message-ID: <20090825000842.GM17684@mit.edu>
References: <20090824093143.GD25591@elf.ucw.cz> <82k50tjw7u.fsf@mid.bfk.de> <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>, Florian Weimer <fweimer@bfk.de>,
	Goswin von Brederlow <goswin-v-b@web.de>,
	Rob Landley <rob@landley.net>,
	kernel list <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@osdl.org>, mtk.manpages@gmail.com,
	rdunlap@xenotime.net, linux-doc@vger.kernel.org,
	linux-ext4@vger.kernel.org, corbet@lwn.net
To: Pavel Machek <pavel@ucw.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:51498 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875AbZHYAJj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 24 Aug 2009 20:09:39 -0400
Content-Disposition: inline
In-Reply-To: <20090824230036.GK29763@elf.ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 25, 2009 at 01:00:36AM +0200, Pavel Machek wrote:
> Then to answer your question... ext2. You expect to run fsck after
> unclean shutdown, and you expect to have to solve some problems with
> it. So the way ext2 deals with the flash media actually matches what
> the user expects. (*)

But if the 256k hole is in data blocks, fsck won't find a problem,
even with ext2.

And if the 256k hole is the inode table, you will *still* suffer
massive data loss.  Fsck will tell you how badly screwed you are, but
it doesn't "fix" the disk; most users don't consider questions of the
form "directory entry <precious-thesis-data> points to trashed inode,
may I delete directory entry?" as being terribly helpful.  :-/

> OTOH in ext3 case you expect consistent filesystem after unplug; and
> you don't get that.

You don't get a consistent filesystem with ext2, either.  And if your
claim is that several hundred lines of fsck output detailing the
filesystem's destruction somehow makes things all better, I suspect
most users would disagree with you.

In any case, depending on where the flash was writing at the time of
the unplug, the data corruption could be silent anyway.

Maybe this came as a surprise to you, but anyone who has used a
compact flash in a digital camera knows that you ***have*** to wait
until the led has gone out before trying to eject the flash card.  I
remember seeing all sorts of horror stories from professional
photographers about how they lost an important wedding's day worth of
pictures with the attendant commercial loss, on various digital
photography forums.  It tends to be the sort of mistake that digital
photographers only make once.

(It's worse with people using Digital SLR's shooting in raw mode,
since it can take upwards of 30 seconds or more to write out a 12-30MB
raw image, and if you eject at the wrong time, you can trash the
contents of the entire CF card; in the worst case, the Flash
Translation Layer data can get corrupted, and the card is completely
ruined; you can't even reformat it at the filesystem level, but have
to get a special Windows program from the CF manufacturer to --maybe--
reset the FTL layer.  Early CF cards were especially vulnerable to
this; more recent CF cards are better, but it's a known failure mode
of CF cards.)

						- Ted
