From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Sat, 20 Sep 2008 11:44:16 -0400
Message-ID: <20080920154416.GA3834@infradead.org>
References: <20080915144754.GA16491@infradead.org> <20080916064514.GH3241@webber.adilger.int> <20080916220346.GB10562@mit.edu> <20080917141840.GB8750@logfs.org> <20080917150212.GD22613@shareable.org> <20080919140502.GA6985@think.oraclecorp.com> <20080919173802.GB17666@shareable.org> <20080920074312.GR5811@disturbed> <20080920135048.GA15698@think.oraclecorp.com> <20080920153633.GA6061@shareable.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chris Mason <chris.mason@oracle.com>, J?rn Engel <joern@logfs.org>,
	Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org, Mark Fasheh <mfasheh@suse.com>,
	mtk.manpages@gmail.com
To: Jamie Lokier <jamie@shareable.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54432 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518AbYITPpX (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Sep 2008 11:45:23 -0400
Content-Disposition: inline
In-Reply-To: <20080920153633.GA6061@shareable.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 20, 2008 at 04:36:34PM +0100, Jamie Lokier wrote:
> > Shrug, either we force the user to do something to get the blocks on
> > disk in a stable location or we have a bootloader that can parse the
> > disk format.  It's either pain on the developers (patching grub) or pain
> > on every user, and the support people who have to remind them to rerun
> > grub-find-the-disk-blocks-just-like-lilo
> 
> I think this thread may be confusing /usr/bin/grub with grub the bootloader.
> 
> One of the useful features of grub the bootloader is that it can boot
> from a real filesystem without needing "run lilo before it's safe to
> boot - or you'll regret shutting down".
> 
> That feature needs to use some kind of bleeding-eyes filesystem code,
> or it will be as large as the filesystem code in Linux.

If the lilo or grub approach is better is at least debatable, but that's
not really the point here.

> On the other hand, any dodgy direct access done by /usr/bin/grub has
> no justification and is fair game for deletion, imho.

That _is_ the real problem.  But we're getting quite offtopic as non
of that is related to FIEMAP anymore ;-)
