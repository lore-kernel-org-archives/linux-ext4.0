From: Kamal Mostafa <kamal@canonical.com>
Subject: Re: [PATCH 10/19] ext4: Convert to new freezing mechanism
Date: Wed, 07 Mar 2012 14:32:13 -0800
Message-ID: <1331159533.12984.73.camel@fourier>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
	 <1330963277-26336-11-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-t26UvHsN9r+MA6GEJEvN"
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
	sandeen@redhat.com, linux-ext4@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:49331 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723Ab2CGWcZ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Mar 2012 17:32:25 -0500
In-Reply-To: <1330963277-26336-11-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


--=-t26UvHsN9r+MA6GEJEvN
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Re: the patch set:
    [PATCH 00/19] Fix filesystem freezing deadlocks

In my initial smoke testing of this, I find that if I freeze a newly
created ext4 filesystem immediately after mounting it for the very first
time, then I get the new SB_FREEZE_COMPLETE warning from
ext4_journal_start_sb() every 0.4 seconds from ext4lazyinit...

        # mkfs -t ext4 /dev/sdaX
        # mount /dev/sdaX /mnt
        # fsfreeze -f /mnt

         WARNING:
        at /home/kamal/src/linux/ubuntu-precise/fs/ext4/super.c:301
        ext4_journal_start_sb+0x159/0x160()
       =20
         Pid: 3252, comm: ext4lazyinit Tainted: G        W
        3.2.0-18-generic #28+kamal1+jankara1
       =20
         Call Trace:
          [<ffffffff8106724f>] warn_slowpath_common+0x7f/0xc0
          [<ffffffff810672aa>] warn_slowpath_null+0x1a/0x20
          [<ffffffff812352c9>] ext4_journal_start_sb+0x159/0x160
          [<ffffffff8121326b>] ? ext4_init_inode_table+0xab/0x370
          [<ffffffff8121326b>] ext4_init_inode_table+0xab/0x370
          [<ffffffff81659cb5>] ? schedule_timeout+0x175/0x320
          [<ffffffff81226905>] ext4_run_li_request+0x85/0xe0
          [<ffffffff812269fc>] ext4_lazyinit_thread+0x9c/0x1c0
          [<ffffffff81226960>] ? ext4_run_li_request+0xe0/0xe0
          [<ffffffff8108a39c>] kthread+0x8c/0xa0
          [<ffffffff81665e34>] kernel_thread_helper+0x4/0x10
          [<ffffffff8108a310>] ? flush_kthread_worker+0xa0/0xa0
          [<ffffffff81665e30>] ? gs_change+0x13/0x13

 -Kamal


On Mon, 2012-03-05 at 17:01 +0100, Jan Kara wrote:
> We remove most of frozen checks since upper layer takes care
> of blocking all writes. We only have to handle protection in
> ext4_page_mkwrite() in a special way because we cannot use
> generic block_page_mkwrite().
>=20
> CC: linux-ext4@vger.kernel.org
> CC: "Theodore Ts'o" <tytso@mit.edu>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/ext4/inode.c |    7 ++-----
>  fs/ext4/super.c |   29 +++++------------------------
>  2 files changed, 7 insertions(+), 29 deletions(-)
>=20
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index feaa82f..c65baf9 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4593,11 +4593,7 @@ int ext4_page_mkwrite(struct vm_area_struct *vma, =
struct vm_fault *vmf)
>  	get_block_t *get_block;
>  	int retries =3D 0;
> =20
> -	/*
> -	 * This check is racy but catches the common case. We rely on
> -	 * __block_page_mkwrite() to do a reliable check.
> -	 */
> -	vfs_check_frozen(inode->i_sb, SB_FREEZE_WRITE);
> +	sb_start_pagefault(inode->i_sb);
>  	/* Delalloc case is easy... */
>  	if (test_opt(inode->i_sb, DELALLOC) &&
>  	    !ext4_should_journal_data(inode) &&
> @@ -4665,5 +4661,6 @@ retry_alloc:
>  out_ret:
>  	ret =3D block_page_mkwrite_return(ret);
>  out:
> +	sb_end_pagefault(inode->i_sb);
>  	return ret;
>  }
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index 502c61f..0f1024a 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -289,33 +289,17 @@ static void ext4_put_nojournal(handle_t *handle)
>   * journal_end calls result in the superblock being marked dirty, so
>   * that sync() will call the filesystem's write_super callback if
>   * appropriate.
> - *
> - * To avoid j_barrier hold in userspace when a user calls freeze(),
> - * ext4 prevents a new handle from being started by s_frozen, which
> - * is in an upper layer.
>   */
>  handle_t *ext4_journal_start_sb(struct super_block *sb, int nblocks)
>  {
>  	journal_t *journal;
> -	handle_t  *handle;
> =20
>  	trace_ext4_journal_start(sb, nblocks, _RET_IP_);
>  	if (sb->s_flags & MS_RDONLY)
>  		return ERR_PTR(-EROFS);
> =20
> +	WARN_ON(sb->s_writers.frozen =3D=3D SB_FREEZE_COMPLETE);
>  	journal =3D EXT4_SB(sb)->s_journal;
> -	handle =3D ext4_journal_current_handle();
> -
> -	/*
> -	 * If a handle has been started, it should be allowed to
> -	 * finish, otherwise deadlock could happen between freeze
> -	 * and others(e.g. truncate) due to the restart of the
> -	 * journal handle if the filesystem is forzen and active
> -	 * handles are not stopped.
> -	 */
> -	if (!handle)
> -		vfs_check_frozen(sb, SB_FREEZE_TRANS);
> -
>  	if (!journal)
>  		return ext4_get_nojournal();
>  	/*
> @@ -4280,10 +4264,8 @@ int ext4_force_commit(struct super_block *sb)
>  		return 0;
> =20
>  	journal =3D EXT4_SB(sb)->s_journal;
> -	if (journal) {
> -		vfs_check_frozen(sb, SB_FREEZE_TRANS);
> +	if (journal)
>  		ret =3D ext4_journal_force_commit(journal);
> -	}
> =20
>  	return ret;
>  }
> @@ -4315,9 +4297,8 @@ static int ext4_sync_fs(struct super_block *sb, int=
 wait)
>   * gives us a chance to flush the journal completely and mark the fs cle=
an.
>   *
>   * Note that only this function cannot bring a filesystem to be in a cle=
an
> - * state independently, because ext4 prevents a new handle from being st=
arted
> - * by @sb->s_frozen, which stays in an upper layer.  It thus needs help =
from
> - * the upper layer.
> + * state independently. It relies on upper layer to stop all data & meta=
data
> + * modifications.
>   */
>  static int ext4_freeze(struct super_block *sb)
>  {
> @@ -4344,7 +4325,7 @@ static int ext4_freeze(struct super_block *sb)
>  	EXT4_CLEAR_INCOMPAT_FEATURE(sb, EXT4_FEATURE_INCOMPAT_RECOVER);
>  	error =3D ext4_commit_super(sb, 1);
>  out:
> -	/* we rely on s_frozen to stop further updates */
> +	/* we rely on upper layer to stop further updates */
>  	jbd2_journal_unlock_updates(EXT4_SB(sb)->s_journal);
>  	return error;
>  }


--=-t26UvHsN9r+MA6GEJEvN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJPV+HtAAoJEHqwmdxYrXhZA4IP/0l5mIjXRP55+IgDI3jPK7fa
OEth+VOAM0RUnf6W/Rzq1iPSp/vNyq6bE5FugfjKhK51xdjdIA9bnbT05VleBaWI
lVGz/wMgq6GQa3DZW+pFa2lOy0mjLZNXNnYlC59J5i+RWPe9whd372+yPcRLLaLo
290xsg8c0Wa7MxUW4W84fCqMiusiwLV0M6FcghWqJDTt8/iDjh/P9FdDEXNyXa8M
t7O9h/wL35JdFXGNKk+Gu5xTjksCi71WNzjWG8LNWX488UuR/iWczleTucZNb6cW
Q1KqnnnrGZtTiiASaMp3eQRjSAmcNzbQD2Ipu4hRR1AEfXj1wDqdFtdC1hwwIG+l
EOdXI4BFJCvCn4dPfHlgnCV+PnYsHhZ6qHfoBVEM1wyEh7ksBiaBjarP/g0EJpHi
Bo0YQQLV96jANi0mZynJtrGtZbb5NmgxfHIxWQ4iwtCv5MHFAdKizEHVZ7DKVAhL
8uHNs/HMFgDQxi98b4p4Rj2WzUnR1o0nA0w2lFnlKN9J85+INz5P1ust/1Z6dp03
13sVD5Kmy1W4n4N7Zi1dhyTCT5gmpZLrYMYbzIP5o5sw9N5ettWmAjK7atT427yY
nSqoYfBD1wAo2N0iHrEmC5f+H6/JlkNeoor6Dv/fqWG5mF8hyvOiPOXy0yPIvbIV
PWjun4TSEtYz8jGyvhxq
=o6lh
-----END PGP SIGNATURE-----

--=-t26UvHsN9r+MA6GEJEvN--

