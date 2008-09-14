From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Sun, 14 Sep 2008 14:01:32 -0400
Message-ID: <20080914180132.GC13074@mit.edu>
References: <E1Kea9F-0004L5-Ds@closure.thunk.org> <1221331767-16870-1-git-send-email-tytso@mit.edu> <20080914134711.GA21746@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org, Mark Fasheh <mfasheh@suse.com>,
	mtk.manpages@gmail.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:55164 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753596AbYINSCO (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sun, 14 Sep 2008 14:02:14 -0400
Content-Disposition: inline
In-Reply-To: <20080914134711.GA21746@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 14, 2008 at 09:47:11AM -0400, Christoph Hellwig wrote:
> On Sat, Sep 13, 2008 at 02:49:24PM -0400, Theodore Ts'o wrote:
> > +* FIEMAP_EXTENT_NO_BYPASS
> > +Direct access to the data in this extent is illegal or will have
> > +undefined results.
> 
> This one is sitll misnamed and for sure utterly misdocumented.  Direct
> access to the data is always illegal and has undefined results, and
> programs that do it anyway (e.g. grub) are in really deep trouble.

Programs like Grub *have* to.  And in the case of a boot-loader, Lilo
and Grub have been able to do so safely for over 15 years.  This is
basically a generic flag that indicates that they can't, but it
reflects the reality that for many filesystems, they *can*.  The main
legal use is LILO and/or Grub, in fact.  One could argue that programs
that try accessing data blocks directly while the filesystem is
mounted are doomed, but boot loaders do so while the filesystem are
unmounted.

The name isn't particularly important, but what it indicates is very
clearly useful.

						- Ted


