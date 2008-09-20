From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Sat, 20 Sep 2008 09:50:49 -0400
Message-ID: <20080920135048.GA15698@think.oraclecorp.com>
References: <20080914180843.GA31649@infradead.org> <20080914195811.GE13074@mit.edu> <20080915144754.GA16491@infradead.org> <20080916064514.GH3241@webber.adilger.int> <20080916220346.GB10562@mit.edu> <20080917141840.GB8750@logfs.org> <20080917150212.GD22613@shareable.org> <20080919140502.GA6985@think.oraclecorp.com> <20080919173802.GB17666@shareable.org> <20080920074312.GR5811@disturbed>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Jamie Lokier <jamie@shareable.org>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger@sun.com>,
	Christoph Hellwig <hch@infradead.o
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:56819 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbYITNwI (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 20 Sep 2008 09:52:08 -0400
Content-Disposition: inline
In-Reply-To: <20080920074312.GR5811@disturbed>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Sep 20, 2008 at 05:43:12PM +1000, Dave Chinner wrote:
> On Fri, Sep 19, 2008 at 06:38:02PM +0100, Jamie Lokier wrote:
> > Chris Mason wrote:
> > > On Wed, Sep 17, 2008 at 04:02:12PM +0100, Jamie Lokier wrote:
> > > > Assume that even reading after unmounting is not 100% safe, because
> > > > the data blocks could be relocated after calling FIEMAP (when the
> > > > filesystem must be mounted), and before the unmount.
> > > 
> > > For the journal case at least, grub can walk through the log of the FS
> > > looking for up to date copies of things.  It does this already for
> > > reiserfs because the btree can't be trusted at all without a log replay.
> 
> OMFG.

Shrug, either we force the user to do something to get the blocks on
disk in a stable location or we have a bootloader that can parse the
disk format.  It's either pain on the developers (patching grub) or pain
on every user, and the support people who have to remind them to rerun
grub-find-the-disk-blocks-just-like-lilo

-chris
