From: Andreas Dilger <adilger@sun.com>
Subject: Re: Error Propagation bugs in ext4
Date: Sat, 22 Nov 2008 11:39:28 -0600
Message-ID: <20081122173928.GO3186@webber.adilger.int>
References: <adb1f7050810311819s3ea0b8f1mbb4239b108f34c4e@mail.gmail.com>
 <adb1f7050811041014r5be96821ie938c313aaf48334@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, cmm@us.ibm.com,
	Ben Liblit <liblit@cs.wisc.edu>
To: Cindy Rubio =?utf-8?Q?Gonz=EF=BF=BDlez?= <crubio@cs.wisc.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:55727 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760071AbYKVRjf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 22 Nov 2008 12:39:35 -0500
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id mAMHdZWo025222
	for <linux-ext4@vger.kernel.org>; Sat, 22 Nov 2008 09:39:35 -0800 (PST)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0KAQ00E01WV0AL00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Sat, 22 Nov 2008 09:39:35 -0800 (PST)
In-reply-to: <adb1f7050811041014r5be96821ie938c313aaf48334@mail.gmail.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Again,
thanks for sending these results to the list.  It is unfortunate that
nobody on the list was able to look through the results until after you=
r
paper submission.

On Nov 04, 2008  12:14 -0600, Cindy Rubio Gonz=EF=BF=BDlez wrote:
> OVERWRITING ERRORS
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> fs/ext4/extents.c:2078: overwriting potential non-tentative unchecked=
 error in "err"
> fs/ext4/extents.c:2082: overwriting potential non-tentative unchecked=
 error in "err"
> fs/ext4/extents.c:2087: overwriting potential non-tentative unchecked=
 error in "err"

I think these are all bugs in the analysis tool as previously mentioned=
=2E
That said, it appears that the error could be overwritten at line 2118
in the same function because the "while (i >=3D 0 && err =3D=3D 0)" loo=
p exits
with "err !=3D 0" and then the check of "if (path->p_hdr->eh_entries =3D=
=3D
0)" is true "err" is re-used.


> OUT OF SCOPE ERRORS:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> fs/ext4/extents.c:2864: potential non-tentative unchecked error in ou=
t of scope variable "err"
>
> UNSAVED ERRORS:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> ext4_block_truncate_page
> fs/ext4/extents.c:2819: potential non-tentative unchecked error is no=
t saved

Unfortunately, the "->truncate" VFS method does not allow an error to b=
e
returned to the caller.  I suspect what we need to do here is check the
error and call ext4_warning() in this case, and mark the filesystem in
error.  I don't think calling ext4_error() is the best course of action
here, because at worst this will result in some blocks being orphaned
until e2fsck is run.  I don't think it is reasonable to force the files=
ystem
read-only or panic the node in such a situation, as it doesn't affect t=
he
correctness of the data or metadata.

> mpage_da_submit_io
> fs/ext4/inode.c:1903: potential non-tentative unchecked error is not =
saved
> fs/ext4/inode.c:1946: potential non-tentative unchecked error is not =
saved
> fs/ext4/inode.c:2050: potential non-tentative unchecked error is not =
saved

Aneesh, could you have a look at these?  I suspect they are possibly
data-losing bugs.

> filemap_write_and_wait
> fs/ext4/inode.c:2562: potential non-tentative unchecked error is not =
saved

The error should just be returned to the caller.

> ext4_get_block
> {FP} fs/ext4/inode.c:3084: potential non-tentative unchecked error is=
 not saved

The error should be returned to the caller.

> ext4_journal_test_restart
> fs/ext4/inode.c:3246: potential non-tentative unchecked error is not =
saved
> fs/ext4/inode.c:3456: potential non-tentative unchecked error is not =
saved

Actually, digging into this one, the only possible source of error is f=
rom
start_this_handle().  There are a number of places where errors could b=
e
returned from this function, but I don't know if any of them will actua=
lly
be "new" failures in the filesystem.

  96             ret =3D -ENOSPC;

This should only happen as a result of a code bug, where the caller is
asking for more journal credits than can possibly fit into the journal.
That isn't to say it is impossible, however.  It might be possible to
track this via static code analysis by monitoring the maximum number
of blocks requested by all of the callers.  The minimum number of
journal transaction blocks is 256 (1/4 of the minimum journal size of
JBD2_MIN_JOURNAL_BLOCKS =3D 1024).


 102             new_transaction =3D kzalloc(sizeof(*new_transaction),
 103                                             GFP_NOFS|__GFP_NOFAIL)=
;
 104             if (!new_transaction) {
 105                     ret =3D -ENOMEM;

This one can't ever be hit, because kzalloc() is called with __GFP_NOFA=
IL,
so the kernel should just spin here forever until memory is available. =
 I
suspect that "if (!new_transaction)" check was added because of previou=
s
static analysis showing that the result of the allocation wasn't checke=
d.

Your analysis needs to be fixed to not tag allocations with __GFP_NOFAI=
L
as TENTATIVE_ENOMEM.

> ext4_mb_try_best_found
> {FP} fs/ext4/mballoc.c:1843: potential non-tentative unchecked error =
is not saved

Does {FP} mean "false positive"?  It does appear that this is the case.
I don't necessarily like the current code construction, however.  If
the allocation status is returned in ->ac_status then the function
should just return void.

> ext4_mb_init_per_dev_proc
> fs/ext4/mballoc.c:2560: potential non-tentative unchecked error is no=
t saved

This is a non-fatal error, and we should just make it a void function.
What it does mean is that all of the code should check if s_mb_proc !=3D=
 NULL
before accessing it.

> ext4_mb_destroy_per_dev_proc
> fs/ext4/mballoc.c:2653: potential non-tentative unchecked error is no=
t saved

This shouldn't return an error either, because it is legal for s_mb_pro=
c
to be NULL if we don't abort the mount if ext4_mb_init_per_dev_proc()
fails at mount time.  This should be a void function, and just return h=
ere.

> ext4_mb_free_metadata
> fs/ext4/mballoc.c:4697: potential non-tentative unchecked error is no=
t saved

Ted re-wrote this code recently, so it isn't worth investigating.  It m=
ight
have been a data corruptor though...

> extend_credit_for_blkde
> fs/ext4/migrate.c:263: potential non-tentative unchecked error is not=
 saved
> fs/ext4/migrate.c:298: potential non-tentative unchecked error is not=
 saved
> fs/ext4/migrate.c:269: potential non-tentative unchecked error is not=
 saved
> fs/ext4/migrate.c:309: potential non-tentative unchecked error is not=
 saved
> fs/ext4/migrate.c:421: potential non-tentative unchecked error is not=
 saved
> ext4_journal_restart
> fs/ext4/migrate.c:598: potential non-tentative unchecked error is not=
 saved

I think this code is in flux, and I don't know many details of it, so I
won't review these cases.

> vfs_quota_off
> fs/ext4/super.c:1746: potential non-tentative unchecked error is not =
saved

Probably Jan Kara can investigate this one further.

> ext4_mb_init
> fs/ext4/super.c:2474: potential non-tentative unchecked error is not =
saved

In this case, if the function has an error it clears the MBALLOC option=
,
and the failure is harmless because that functionality is not used.
That said, in newer kernels the MBALLOC functionality is required and
this error needs to be checked and mounting failed if there is an error=
=2E

> set_blocksize
> fs/ext4/super.c:2608: potential non-tentative unchecked error is not =
saved

This is a false positive, in the sense that bdev_hardsect_size(bdev) wa=
s
checked a few lines earlier to be at most the filesystem blocksize, so
the only failure condition in set_blocksize() cannot be hit.  That said=
,
the extra bdev_hardsect_size() check in ext4_fill_super() could be remo=
ved
and we just check the return value from set_blocksize() directly.  That
removes some logic that ext4 doesn't really need to know about.

> sync_dirty_buffer
> fs/ext4/super.c:2808: potential non-tentative unchecked error is not =
saved

Most of the callers of ext4_commit_super() are void, so there isn't rea=
lly
any place to report the error to.  Since this is an error trying to wri=
te
out the superblock, I suspect that we should return the error.  In some
places we can call ext4_error(), but not in ext4_handle_error() or a fe=
w
others (which would cause recursion).  In others like ext4_create_journ=
al()
we can just return the error and fail the mount.

> jbd2_journal_clear_err
> fs/ext4/super.c:2868: potential non-tentative unchecked error is not =
saved

I don't know why ext4_clear_journal_err() is void.  The error should ju=
st be
returned to the caller and the mount failed.

> jbd2_log_wait_commit
> fs/ext4/super.c:2913: potential non-tentative unchecked error is not =
saved
>=20
> sync_blockdev
> fs/ext4/super.c:544: potential non-tentative unchecked error is not s=
aved

Not sure what can be done here.  The filesystem is just finished being
unmounted, so there isn't anywhere that an error can be returned, and
the filesystem can't even be marked in error.  I suppose it wouldn't
hurt to check the return value and print a warning this case like

	ext4_warning(sb, "write error at unmount, may be inconsistent\n");

> Additional:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> ext4_mark_inode_dirty
> fs/ext4/acl.c:245: potential non-tentative unchecked error is not sav=
ed

This looks like a simple case where the error should be checked and
returned, but I don't know much about the ACL code, so it may need some
extra cleanup.

> ext4_journal_stop
> fs/ext4/acl.c:405: potential non-tentative unchecked error is not sav=
ed
> fs/ext4/acl.c:512: potential non-tentative unchecked error is not sav=
ed
> fs/ext4/extents.c:2027: potential non-tentative unchecked error is no=
t saved
> fs/ext4/extents.c:2130: potential non-tentative unchecked error is no=
t saved
> fs/ext4/extents.c:2863: potential non-tentative unchecked error is no=
t saved
> :
> :

In ext4_journal_stop() it always checks and calls __ext4_std_error()
and ext4_handle_error() to handle an error.  I suspect there should be
error handling in the callers for the case where the filesystem is
mounted with errors=3Dcontinue, but that is no the default behaviour of
ext4 anymore.

> ext4_forget
> ext4_ext_dirty
> ext4_mark_inode_dirty
> ext4_orphan_del
> ext4_journal_get_write_access
> ext4_orphan_add
> ext4_mark_iloc_dirty

Sorry, getting to the end of my flight here, and can't continue to
look at the rest of these error cases.  I think in most of the cases
the checker has produced valid errors.  If the {FP} cases where found
automatically, then they probably shouldn't be listed at all.  I
didn't look at any but the first one.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
