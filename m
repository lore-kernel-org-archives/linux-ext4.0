From: Eric Whitney <enwlinux@gmail.com>
Subject: Re: [PATCH] ext4: fix loss of delalloc extent info in
 ext4_zero_range()
Date: Mon, 23 Mar 2015 13:55:08 -0400
Message-ID: <20150323175508.GA3422@wallace>
References: <20150320235350.GA10101@wallace>
 <alpine.LFD.2.00.1503231138110.1578@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org,
	tytso@mit.edu
To: =?utf-8?B?THVrw6HFoQ==?= Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:36197 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221AbbCWRzc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 23 Mar 2015 13:55:32 -0400
Received: by qgez102 with SMTP id z102so67750898qge.3
        for <linux-ext4@vger.kernel.org>; Mon, 23 Mar 2015 10:55:32 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1503231138110.1578@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

* Luk=C3=A1=C5=A1 Czerner <lczerner@redhat.com>:
> On Fri, 20 Mar 2015, Eric Whitney wrote:
>=20
> > Date: Fri, 20 Mar 2015 19:53:50 -0400
> > From: Eric Whitney <enwlinux@gmail.com>
> > To: linux-ext4@vger.kernel.org
> > Cc: tytso@mit.edu
> > Subject: [PATCH] ext4: fix loss of delalloc extent info in ext4_zer=
o_range()
> >=20
> > In ext4_zero_range(), removing a file's entire block range from the
> > extent status tree removes all records of that file's delalloc exte=
nts.
> > The delalloc accounting code uses this information, and its loss ca=
n
> > then lead to accounting errors and kernel warnings at writeback tim=
e and
> > subsequent file system damage.  This is most noticeable on bigalloc
> > file systems where code in ext4_ext_map_blocks() handles cases wher=
e
> > delalloc extents share clusters with a newly allocated extent.
> >=20
> > Because we're not deleting a block range and are correctly updating=
 the
> > status of its associated extent, there is no need to remove anythin=
g
> > from the extent status tree.
> >=20
> > When this patch is combined with an unrelated bug fix for
> > ext4_zero_range(), kernel warnings and e2fsck errors reported durin=
g
> > xfstests runs on bigalloc filesystems are greatly reduced without
> > introducing regressions on other xfstests-bld test scenarios.
>=20
> Ah, this is my bad sorry. I didn't realize that we're actually
> relying on the delayed extent information in the extent status tree
> now.
>=20
> However I remember that I've seen some problems when this extent
> removal was not there (see the comment you removed). I am not
> entirely sure anymore what it was all about, but I need to retest
> with your patch.
>=20

Hi Lukas:

=46or a little more context, the unrelated bug fix I referenced is in f=
act
your pending zero_range fix.  Without it, xfstests-bld runs on a kernel
with this patch applied will report test failures for generic/091 prett=
y
consistently and for generic/127 occasionally on various test scenarios
(including 4k, ext4, bigalloc, etc.).  With your patch, things look pre=
tty
good to me.  (It's still possible to encounter occasional kernel warnin=
gs
related to delalloc reserved space accounting during bigalloc runs, but=
 I
think those are related to another area I'm working on.)

We don't appear to have a record of the problems mentioned in the comme=
nt
I removed, and Ted doesn't recall what he might have seen.  Since that
code was introduced a couple of releases ago, I'm speculating he might
possibly have been seeing the xfstests failures described above before =
you
posted your patch.

Any test results you can share would be very welcome - taken together, =
these
two patches address a bunch of test failures and kernel warning noise o=
n
bigalloc.  There are developers who want to do some ext4 SMR work lever=
aging
bigalloc right now, so if we can clear that up it will make things easi=
er for
them.

Thanks,
Eric




> Thanks!
> -Lukas
>=20
> >=20
> > Signed-off-by: Eric Whitney <enwlinux@gmail.com>
> > ---
> >  fs/ext4/extents.c | 13 -------------
> >  1 file changed, 13 deletions(-)
> >=20
> > diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
> > index bed4308..c187cc3 100644
> > --- a/fs/ext4/extents.c
> > +++ b/fs/ext4/extents.c
> > @@ -4847,19 +4847,6 @@ static long ext4_zero_range(struct file *fil=
e, loff_t offset,
> >  					     flags, mode);
> >  		if (ret)
> >  			goto out_dio;
> > -		/*
> > -		 * Remove entire range from the extent status tree.
> > -		 *
> > -		 * ext4_es_remove_extent(inode, lblk, max_blocks) is
> > -		 * NOT sufficient.  I'm not sure why this is the case,
> > -		 * but let's be conservative and remove the extent
> > -		 * status tree for the entire inode.  There should be
> > -		 * no outstanding delalloc extents thanks to the
> > -		 * filemap_write_and_wait_range() call above.
> > -		 */
> > -		ret =3D ext4_es_remove_extent(inode, 0, EXT_MAX_BLOCKS);
> > -		if (ret)
> > -			goto out_dio;
> >  	}
> >  	if (!partial_begin && !partial_end)
> >  		goto out_dio;
> >=20
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
