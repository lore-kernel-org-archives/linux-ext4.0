From: Dmitriy Monakhov <dmonakhov@openvz.org>
Subject: Re: + fs-introduce-write_begin-write_end-and-perform_write-aops.patch added to -mm tree
Date: Wed, 13 Jun 2007 17:40:05 +0400
Message-ID: <20070613134005.GA13815@localhost.sw.ru>
References: <200705292119.l4TLJtAD011726@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: npiggin@suse.de, mark.fasheh@oracle.com, dmonakhov@openvz.org,
	linux-ext4@vger.kernel.org
To: linux-kernel@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:6605 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757427AbXFMKjo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Jun 2007 06:39:44 -0400
Content-Disposition: inline
In-Reply-To: <200705292119.l4TLJtAD011726@shell0.pdx.osdl.net>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 14:19 =D0=92=D1=82=D1=80 29 =D0=9C=D0=B0=D0=B9     , akpm@linux-foun=
dation.org wrote:
>=20
> The patch titled
>      fs: introduce write_begin, write_end, and perform_write aops
> has been added to the -mm tree.  Its filename is
>      fs-introduce-write_begin-write_end-and-perform_write-aops.patch
>=20
> *** Remember to use Documentation/SubmitChecklist when testing your c=
ode ***
>=20
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt t=
o find
> out what to do about this
>=20
> ------------------------------------------------------
> Subject: fs: introduce write_begin, write_end, and perform_write aops
> From: Nick Piggin <npiggin@suse.de>
>=20
> These are intended to replace prepare_write and commit_write with mor=
e
> flexible alternatives that are also able to avoid the buffered write
> deadlock problems efficiently (which prepare_write is unable to do).
>=20
> [mark.fasheh@oracle.com: API design contributions, code review and fi=
xes]
> Signed-off-by: Nick Piggin <npiggin@suse.de>
> Signed-off-by: Mark Fasheh <mark.fasheh@oracle.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
I've finaly find time to review Nick's "write_begin/write_end aop" patc=
h set.
And i have some fixes and questions. My be i've missed somthing and it =
was=20
already disscussed, but i cant find in LKML.

1) loop dev:
	loop.c code itself is not perfect. In fact before Nick's patch
	partial write was't possible. Assumption what write chunks are
	always page aligned is realy weird ( see "index++" line).
	Fixed by "new aop loop fix" patch

2)block_write_begin:
	After we enter to block_write_begin with *pagep =3D=3D NULL and
	some page was grabed we remember this page in *pagep
	And if __block_prepare_write() we have to clear *pagep , as=20
	it was before. Because this may confuse caller.
	for example caller may have folowing code:
		ret =3D block_write_begin(..., pagep,...)
		if (ret && *pagep !=3D NULL) {
			unlock_page(*pagep);
			page_cache_release(*pagep);
		}
	Fixed my "new aop block_write_begin fix" patch

3) __page_symlink:
	Nick's patch add folowing code:
	+ err =3D pagecache_write_begin(NULL, mapping, 0,PAGE_CACHE_SIZE,
	+                 AOP_FLAG_UNINTERRUPTIBLE, &page,&fsdata);
	symlink now consume whole page. I have only one question "WHY???".
	I don't see any advantages, but where are huge list of
	dissdvantages:
	a) fs with blksize =3D=3D 1k and pagesize =3D=3D 16k after this patch
	   waste more than 10x times disk space for nothing.
	b) What happends if we want use fs with blksize =3D=3D 4k on i386
	   after it was used by ia64 ??? (before this patch it was
	   possible).
=09
	I dont prepare patch for this because i dont understand issue
	witch Nick aimed to fix.

4) iov_iter_fault_in_readable:
	Function prerform check for signgle region, with out respect to
	segment nature of iovec, For example writev no longer works :) :
	writev(3, [{"\1", 1}, {"\2"..., 4096}], 2) =3D -1 EFAULT (Bad address)
	this hidden bug, and it was invisiable because XXXX_fault_in_readable
	return value was ignored before. Lets iov_iter_fault_in_readable
	perform checks for all segments.
	Fixed by :"iov_iter_fault_in_readable fix"

5) ext3_write_end:
	Before  write_begin/write_end patch set we have folowing locking
	order:
		stop_journal(handle);
		unlock_page(page);
	But now order is oposite:
		unlock_page(page);
		stop_journal(handle);
	Can we got any race condition now? I'm not sure is it actual problem,
	may be somebody cant describe this.
