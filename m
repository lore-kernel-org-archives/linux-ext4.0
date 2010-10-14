From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH RFC 0/3] Block reservation for ext3
Date: Thu, 14 Oct 2010 17:57:36 +0200
Message-ID: <20101014155735.GE3482@quack.suse.cz>
References: <1286583147-14760-1-git-send-email-jack@suse.cz>
 <20101009180357.GG18454@thunk.org>
 <20101011142813.GC3830@quack.suse.cz>
 <20101011145945.166695e3.akpm@linux-foundation.org>
 <20101012231408.GC3812@quack.suse.cz>
 <AANLkTimqbW7+wsXVoLa1Tx0K3VaDfrYKUE8owyD1VUxO@mail.gmail.com>
 <AANLkTinD=EE0yYFzBHdvu-fKCQhfMH+DetekHWd-RZc7@mail.gmail.com>
 <AANLkTi=GNqOgN0baLVckQcY4FYoMwvjCgVedmWACES1R@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:55870 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335Ab0JNP6h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 14 Oct 2010 11:58:37 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTi=GNqOgN0baLVckQcY4FYoMwvjCgVedmWACES1R@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 13-10-10 18:14:08, Amir G. wrote:
> On Wed, Oct 13, 2010 at 10:49 AM, Amir G.
> <amir73il@users.sourceforge.net> wrote:
> > On Wed, Oct 13, 2010 at 1:14 AM, Jan Kara <jack@suse.cz> wrote:
> >> > When I did ext2 delayed allocation back in, err, 2001 I had
> >> > considerable trouble working out how many blocks to actually res=
erve
> >> > for a file block, because it also had to reserve the indirect bl=
ocks.
> >> > One file block allocation can result in reserving four disk bloc=
ks!
> >> > And iirc it was not possible with existing in-core data structur=
es to
> >> > work out whether all four blocks needed reserving until the actu=
al
> >> > block allocation had occurred. =A0So I ended up reserving the wo=
rst-case
> >> > number of indirects, based upon the file offset. =A0If the disk =
ran out
> >> > of "space" I'd do a forced writeback to empty all the reservatio=
ns and
> >> > would then take a look to see if the disk was _really_ out of sp=
ace.
> >> >
> >> > Is all of this an issue with this work? =A0If so, what approach =
did you
> >> > take?
> >> =A0Yeah, I've spotted exactly the same problem. How I decided to s=
olve it in
> >> the end is that in memory we keep track of each indirect block tha=
t has
> >> delay-allocated buffer under it. This allows us to reserve space f=
or each
> >> indirect block at most once (I didn't bother with making the accou=
nting
> >> precise for double or triple indirect blocks so when I need to res=
erve
> >> space for indirect block, I reserve the whole path just to be sure=
). This
> >> pushes the error in estimation to rather acceptable range for reas=
onably
> >> common workloads - the error can still be 50% for workloads which =
use just
> >> one data block in each indirect block but even in this case the ab=
solute
> >> number of blocks falsely reserved is small.
> >> =A0The cost is of course increased complexity of the code, the mem=
ory
> >> spent for tracking those indirect blocks (32 bytes per indirect bl=
ock), and
> >> some time for lookups in the RB-tree of the structures. At least t=
he nice
> >> thing is that when there are no delay-allocated blocks, there isn'=
t any
> >> overhead (tree is empty).
> >>
> >
> > How about allocating *only* the indirect blocks on page fault.
> > IMHO it seems like a fair mixture of high quota accuracy, low
> > complexity of the accounting code and low file fragmentation (only
> > indirect may be a bit further away from data).
> >
> > In my snapshot patches I use the @create arg to get_blocks_handle()=
 to
> > pass commands just like "allocate only indirect blocks".
> > The patch is rather simple. I can prepare it for ext3 if you like.
>=20
> Here is the indirect allocation patch.
> The following debugfs dump shows the difference between a 1G file
> allocated by dd (indirect interleaved with data) and by mmap (indirec=
t
> sequential before data).
> (I did not test performance and I ignored SIGBUS at the end of mmap
> file allocation)
=2E..
>=20
> Allocate file indirect blocks on page_mkwrite().
>=20
> This is a sample patch to be merged with Jan Kara's ext3 delayed allo=
cation
> patches. Some of the code was taken from Jan's patches for testing on=
ly.
> This patch is for kernel 2.6.35.6.
>=20
> On page_mkwrite(), we allocate indirect blocks if needed and leave th=
e data
> blocks unallocated. Jan's patches take care of reserving space for th=
e data.
  Thanks for the idea and the patch.

  Yes, this is one of the trade-off options. But it's not that simple.
There's a problem with with truncate coming after page_mkwrite but befo=
re
the allocation happens. See:

  ext3_page_mkwrite() for page index 70
    -> allocates the indirect block (or just sees that it's allocated
       and does nothing)
    - marks buffer as delayed
  ...
  truncate to index 80
    - sees indirect block has no more blocks allocated and removes it

  ext3_writepage() for index 70
    - would like to allocate block for index 70 but indirect block does
      not exist. Bugger.

  So you have to somehow track that indirect block has some delayed
allocation pending - and that is the most complex part of my patch. The
rest is rather simple...
  Actually, there are also other ways to track that indirect block has =
the
delayed allocation pending. For example if we could do a disk format
change, we could simply reserve say block number 1 or -1 to indicate de=
layed
allocated block and everything would be much simpler. But I don't think=
 we
really can (it would be an incompatible disk format change).
  Hmm, using radix tree dirty tag could also work for that -- when the
range covered by an indirect block has some dirty pages we know that we
shouldn't delete it because it's going to be used soon. But it's subtle
because we rely on the fact that radix tree dirty tag is cleared only i=
n
set_page_writeback() which is after the get_block() call while page dir=
ty
flag is already cleared before the writepage() (and thus get_block()) c=
all
-- I originally discared this idea because I forgot about this tag hand=
ling
subtlety.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
