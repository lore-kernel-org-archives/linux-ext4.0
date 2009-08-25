From: Theodore Tso <tytso@mit.edu>
Subject: Re: [patch] ext2/3: document conditions when reliable operation is
	possible
Date: Tue, 25 Aug 2009 12:11:10 -0400
Message-ID: <20090825161110.GP17684@mit.edu>
References: <20090824130125.GG23677@mit.edu> <20090824195159.GD29763@elf.ucw.cz> <4A92F6FC.4060907@redhat.com> <20090824205209.GE29763@elf.ucw.cz> <4A930160.8060508@redhat.com> <20090824212518.GF29763@elf.ucw.cz> <20090824223915.GI17684@mit.edu> <20090824230036.GK29763@elf.ucw.cz> <20090825000842.GM17684@mit.edu> <20090825094244.GC15563@elf.ucw.cz>
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
Received: from THUNK.ORG ([69.25.196.29]:36169 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755562AbZHYSiq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Aug 2009 14:38:46 -0400
Content-Disposition: inline
In-Reply-To: <20090825094244.GC15563@elf.ucw.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

It seems that you are really hung up on whether or not the filesystem
metadata is consistent after a power failure, when I'd argue that the
problem with using storage devices that don't have good powerfail
properties have much bigger problems (such as the potential for silent
data corruption, or even if fsck will fix a trashed inode table with
ext2, massive data loss).  So instead of your suggested patch, it
might be better simply to have a file in Documentation/filesystems
that states something along the lines of:

"There are storage devices that high highly undesirable properties
when they are disconnected or suffer power failures while writes are
in progress; such devices include flash devices and software RAID 5/6
arrays without journals, as well as hardware RAID 5/6 devices without
battery backups.  These devices have the property of potentially
corrupting blocks being written at the time of the power failure, and
worse yet, amplifying the region where blocks are corrupted such that
adjacent sectors are also damaged during the power failure.

Users who use such storage devices are well advised take
countermeasures, such as the use of Uninterruptible Power Supplies,
and making sure the flash device is not hot-unplugged while the device
is being used.  Regular backups when using these devices is also a
Very Good Idea.

Otherwise, file systems placed on these devices can suffer silent data
and file system corruption.  An forced use of fsck may detect metadata
corruption resulting in file system corruption, but will not suffice
to detect data corruption."

My big complaint is that you seem to think that ext3 some how let you
down, but I'd argue that the real issue is that the storage device let
you down.  Any journaling filesystem will have the properties that you
seem to be complaining about, so the fact that your patch only
documents this as assumptions made by ext2 and ext3 is unfair; it also
applies to xfs, jfs, reiserfs, reiser4, etc.  Further more, most users
are even more concerned about possibility of massive data loss and/or
silent data corruption.  So if your complaint that we don't have
documentation warning users about the potential pitfalls of using
storage devices with undesirable power fail properties, let's document
that as a shortcoming in those storage devices.

						- Ted
