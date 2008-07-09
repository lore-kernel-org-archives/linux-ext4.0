From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3/3] Add timeout feature
Date: Wed, 9 Jul 2008 16:59:50 +1000
Message-ID: <20080709065950.GR11558@disturbed>
References: <20080701081026.GB16691@infradead.org> <20080707110730.GG5643@ucw.cz> <20080708231026.GP11558@disturbed> <20080708232031.GE18195@elf.ucw.cz> <20080709005254.GQ11558@disturbed> <20080709010922.GE9957@mit.edu> <E1KGSvZ-0006dB-53@pomaz-ex.szeredi.hu> <20080709061621.GA5260@infradead.org> <E1KGT4q-0006fD-Jb@pomaz-ex.szeredi.hu> <20080708234120.5072111f@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
	tytso@mit.edu, pavel@suse.cz, t-sato@yk.jp.nec.com,
	akpm@linux-foundation.org, viro@ZenIV.linux.org.uk,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	axboe@kernel.dk, mtk.manpages@googlemail.com
To: Arjan van de Ven <arjan@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:58871 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752551AbYGIG77 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 9 Jul 2008 02:59:59 -0400
Content-Disposition: inline
In-Reply-To: <20080708234120.5072111f@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 08, 2008 at 11:41:20PM -0700, Arjan van de Ven wrote:
> On Wed, 09 Jul 2008 08:22:56 +0200
> Miklos Szeredi <miklos@szeredi.hu> wrote:
> > > On Wed, Jul 09, 2008 at 08:13:21AM +0200, Miklos Szeredi wrote:
> > > > This would mean that freeze and thaw will have to be done on the
> > > > same file descriptor, but this isn't unreasonable to expect, is
> > > > it?
> > > 
> > > It is certainly not the current use case, where you run one command
> > > to freeze the filesystem and another one to unfreeze it.
> > 
> > So instead of
> > 
> >   freeze_fs mountpoint
> >   backup-command
> >   unfreeze_fs mountpoint
> > 
> > the user would have do to
> > 
> >   run_freezed mountpoint backup-command
> > 
> > I find the second one nicer, regardless of any reliability issues.
> 
> nah he needs to do
> 
> make_snapshot ; backup-command ; unref_snapshot.
> 
> freezing isn't the right solution for the backup problem ;)

You're forgetting that to take a snapshot you generally need to
freeze the filesystem. ;) i.e:

freeze; make_snapshot; unfreeze
backup-command
unref_snapshot

Yes, dm_snapshot does the freeze/snapshot/unfreeze for you, but the
point is there is a freeze in the example you gave.

The argument against Miklos' version is that there may be multiple
commands to execute while the fs is frozen.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
