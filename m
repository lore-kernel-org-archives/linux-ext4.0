From: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Sat, 20 Sep 2008 16:36:34 +0100
Message-ID: <20080920153633.GA6061@shareable.org>
References: <20080914195811.GE13074@mit.edu> <20080915144754.GA16491@infradead.org> <20080916064514.GH3241@webber.adilger.int> <20080916220346.GB10562@mit.edu> <20080917141840.GB8750@logfs.org> <20080917150212.GD22613@shareable.org> <20080919140502.GA6985@think.oraclecorp.com> <20080919173802.GB17666@shareable.org> <20080920074312.GR5811@disturbed> <20080920135048.GA15698@think.oraclecorp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org, Mark Fasheh <mfasheh@suse.com>,
	mtk.manpages@gmail.com
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail2.shareable.org ([80.68.89.115]:44181 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbYITPhL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Sep 2008 11:37:11 -0400
Content-Disposition: inline
In-Reply-To: <20080920135048.GA15698@think.oraclecorp.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Chris Mason wrote:
> > > > For the journal case at least, grub can walk through the log of the FS
> > > > looking for up to date copies of things.  It does this already for
> > > > reiserfs because the btree can't be trusted at all without a log replay.
> > OMFG.
> 
> Shrug, either we force the user to do something to get the blocks on
> disk in a stable location or we have a bootloader that can parse the
> disk format.  It's either pain on the developers (patching grub) or pain
> on every user, and the support people who have to remind them to rerun
> grub-find-the-disk-blocks-just-like-lilo

I think this thread may be confusing /usr/bin/grub with grub the bootloader.

One of the useful features of grub the bootloader is that it can boot
from a real filesystem without needing "run lilo before it's safe to
boot - or you'll regret shutting down".

That feature needs to use some kind of bleeding-eyes filesystem code,
or it will be as large as the filesystem code in Linux.

On the other hand, any dodgy direct access done by /usr/bin/grub has
no justification and is fair game for deletion, imho.

-- Jamie
