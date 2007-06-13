From: Dmitriy Monakhov <dmonakhov@sw.ru>
Subject: Re: + fs-introduce-write_begin-write_end-and-perform_write-aops.patch added to -mm tree
Date: Wed, 13 Jun 2007 22:51:46 +0400
Message-ID: <20070613185146.GF13815@localhost.sw.ru>
References: <200705292119.l4TLJtAD011726@shell0.pdx.osdl.net> <20070613134005.GA13815@localhost.sw.ru> <20070613114356.GD17547@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-kernel@vger.kernel.org, mark.fasheh@oracle.com,
	linux-ext4@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <npiggin@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:4262 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758312AbXFMPvZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Jun 2007 11:51:25 -0400
Content-Disposition: inline
In-Reply-To: <20070613114356.GD17547@wotan.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 13:43 =D0=A1=D1=80=D0=B4 13 =D0=98=D1=8E=D0=BD     , Nick Piggin wro=
te:
> On Wed, Jun 13, 2007 at 05:40:05PM +0400, Dmitriy Monakhov wrote:
> > On 14:19 ?????? 29 ??????     , akpm@linux-foundation.org wrote:
> > >=20
> > > The patch titled
> > >      fs: introduce write_begin, write_end, and perform_write aops
> > > has been added to the -mm tree.  Its filename is
> > >      fs-introduce-write_begin-write_end-and-perform_write-aops.pa=
tch
> > >=20
> > > *** Remember to use Documentation/SubmitChecklist when testing yo=
ur code ***
> > >=20
> > > See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.t=
xt to find
> > > out what to do about this
> > >=20
> > > ------------------------------------------------------
> > > Subject: fs: introduce write_begin, write_end, and perform_write =
aops
> > > From: Nick Piggin <npiggin@suse.de>
> > >=20
> > > These are intended to replace prepare_writ eand commit_write with=
 more
> > > flexible alternatives that are also able to avoid the buffered wr=
ite
> > > deadlock problems efficiently (which prepare_write is unable to d=
o).
> > >=20
> > > [mark.fasheh@oracle.com: API design contributions, code review an=
d fixes]
> > > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > > Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
> > > Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > I've finaly find time to review Nick's "write_begin/write_end aop" =
patch set.
> > And i have some fixes and questions. My be i've missed somthing and=
 it was=20
> > already disscussed, but i cant find in LKML.
>=20
> Thanks, that's really helpful.
>=20
> =20
> > 1) loop dev:
> > 	loop.c code itself is not perfect. In fact before Nick's patch
> > 	partial write was't possible. Assumption what write chunks are
> > 	always page aligned is realy weird ( see "index++" line).
> > 	Fixed by "new aop loop fix" patch
>=20
> I think you're right, fix looks good.
>=20
> =20
> > 2)block_write_begin:
> > 	After we enter to block_write_begin with *pagep =3D=3D NULL and
> > 	some page was grabed we remember this page in *pagep
> > 	And if __block_prepare_write() we have to clear *pagep , as=20
> > 	it was before. Because this may confuse caller.
> > 	for example caller may have folowing code:
> > 		ret =3D block_write_begin(..., pagep,...)
> > 		if (ret && *pagep !=3D NULL) {
> > 			unlock_page(*pagep);
> > 			page_cache_release(*pagep);
> > 		}
> > 	Fixed my "new aop block_write_begin fix" patch
>=20
> I don't think the caller can rely on that if it returns failure.
> But that is more defensive I guess. Maybe setting it to 1 or
> so would catch abusers.
>=20
> =20
> > 3) __page_symlink:
> > 	Nick's patch add folowing code:
> > 	+ err =3D pagecache_write_begin(NULL, mapping, 0,PAGE_CACHE_SIZE,
> > 	+                 AOP_FLAG_UNINTERRUPTIBLE, &page,&fsdata);
> > 	symlink now consume whole page. I have only one question "WHY???".
> > 	I don't see any advantages, but where are huge list of
> > 	dissdvantages:
> > 	a) fs with blksize =3D=3D 1k and pagesize =3D=3D 16k after this pa=
tch
> > 	   waste more than 10x times disk space for nothing.
> > 	b) What happends if we want use fs with blksize =3D=3D 4k on i386
> > 	   after it was used by ia64 ??? (before this patch it was
> > 	   possible).
One more visiable effect caused by wrong symlink size:
fsstress cause folowing error:
<LOG BEGIN>
EXT3-fs unexpected failure: !buffer_revoked(bh);=20
inconsistent data on disk
ext3_forget: aborting transaction: IO failure in __ext3_journal_revoke
ext3_abort called.

EXT3-fs error (device dm-4): ext3_forget: error -5 when attempting
revoke
Remounting filesystem read-only=20
Aborting journal on device dm-4.
journal commit I/O error
journal commit I/O error
journal commit I/O error
journal commit I/O error
journal commit I/O error
journal commit I/O error
EXT3-fs error (device dm-4) in ext3_free_blocks_sb: Journal has aborted

journal commit I/O error
journal commit I/O error
EXT3-fs error (device dm-4) in ext3_reserve_inode_write: Journal has
aborted
EXT3-fs error (device dm-4) in ext3_truncate: IO failure
journal commit I/O error
journal commit I/O error
journal commit I/O error
journal commit I/O error
EXT3-fs error (device dm-4) in ext3_reserve_inode_write: Journal has
aborted
EXT3-fs error (device dm-4) in ext3_orphan_del: Journal has aborted
EXT3-fs error (device dm-4) in ext3_reserve_inode_write: Journal has
aborted
EXT3-fs error (device dm-4) in ext3_delete_inode: IO failure
<LOG END>

After symlink size was fixed to len-1 problem dissappeared.=20
> > =09
> > 	I dont prepare patch for this because i dont understand issue
> > 	witch Nick aimed to fix.
>=20
> I don't know why myself :P I think it would be just fine to use
> len-1 as it did previously, so it must have been a typo?
>=20
>=20
> > 4) iov_iter_fault_in_readable:
> > 	Function prerform check for signgle region, with out respect to
> > 	segment nature of iovec, For example writev no longer works :) :
> > 	writev(3, [{"\1", 1}, {"\2"..., 4096}], 2) =3D -1 EFAULT (Bad addr=
ess)
> > 	this hidden bug, and it was invisiable because XXXX_fault_in_reada=
ble
> > 	return value was ignored before. Lets iov_iter_fault_in_readable
> > 	perform checks for all segments.
> > 	Fixed by :"iov_iter_fault_in_readable fix"
>=20
> OK thanks. I would rather just change this to use the length of
> the first iovec always (prefaulting multiple iovecs would have to
> be benchmarked on real apps that make heavy use of writev, I
> suspect).
>=20
> =20
> > 5) ext3_write_end:
> > 	Before  write_begin/write_end patch set we have folowing locking
> > 	order:
> > 		stop_journal(handle);
> > 		unlock_page(page);
> > 	But now order is oposite:
> > 		unlock_page(page);
> > 		stop_journal(handle);
> > 	Can we got any race condition now? I'm not sure is it actual probl=
em,
> > 	may be somebody cant describe this.
>=20
> Can we just change it to the original order? That would seem to be
> safest unless one of the ext3 devs explicitly acks it.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
