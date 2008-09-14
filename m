From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/4] vfs: vfs-level fiemap interface
Date: Sun, 14 Sep 2008 14:08:44 -0400
Message-ID: <20080914180843.GA31649@infradead.org>
References: <E1Kea9F-0004L5-Ds@closure.thunk.org> <1221331767-16870-1-git-send-email-tytso@mit.edu> <20080914134711.GA21746@infradead.org> <20080914180132.GC13074@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	akpm@linuxfoundation.org, Mark Fasheh <mfasheh@suse.com>,
	mtk.manpages@gmail.com
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080914180132.GC13074@mit.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Sep 14, 2008 at 02:01:32PM -0400, Theodore Tso wrote:
> On Sun, Sep 14, 2008 at 09:47:11AM -0400, Christoph Hellwig wrote:
> > On Sat, Sep 13, 2008 at 02:49:24PM -0400, Theodore Ts'o wrote:
> > > +* FIEMAP_EXTENT_NO_BYPASS
> > > +Direct access to the data in this extent is illegal or will have
> > > +undefined results.
> > 
> > This one is sitll misnamed and for sure utterly misdocumented.  Direct
> > access to the data is always illegal and has undefined results, and
> > programs that do it anyway (e.g. grub) are in really deep trouble.
> 
> Programs like Grub *have* to.

Depends on which grub you mean.  Grub that boot loader has a filesystem
driver and accesses it, that's fine.  /usr/sbin/grub, the installation
program doesn't have to.  In fact the only reason why it does is to
"verify" that blocks are in place.  This breaks down depending on the
phase of the moon, but especially badly on filesystems using a different
address space than the block device one.

> And in the case of a boot-loader, Lilo
> and Grub have been able to do so safely for over 15 years.

I think your arguing 100% profs my point that the flag name and
description are utterly confusing.  What lilo does is load a kernel
from an offset into the partition.  This is obviously fine, and a
perfect use case for an extent map / block map interface.  I think
(but not one could clarify to me) that this is the primary use case
of the no bypass flag, which is supposed to tell lilo that this extent
is not actually a real block but some sort of meshup and lilo should
return an error that it gets.  But this flag is totally unrelated
to beeing able to bypass the filesystem driver when running the kernel
which is always bogus, and has caused endless amounts of trouble with
the only widespread tool that does it (/usr/sbin/grub).

> The name isn't particularly important, but what it indicates is very
> clearly useful.

Sometimes I really wish people would read email before replying to them.
I did not say anywhere that this flag (at least for the use case I think
it is which no one even bothered to document) is good, but the name
and description are utterly wrong, and misleading.
