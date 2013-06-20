From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fs/jbd2: t_updates should increase when
 start_this_handle() failed in jbd2__journal_restart()
Date: Thu, 20 Jun 2013 11:55:55 -0400
Message-ID: <20130620155555.GE28309@thunk.org>
References: <51C1381A.2@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-ext4@vger.kernel.org,
	Ocfs2-Devel <ocfs2-devel@oss.oracle.com>,
	Li Zefan <lizefan@huawei.com>, jack@suse.cz
To: Younger Liu <younger.liu@huawei.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <51C1381A.2@huawei.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

[ LKML and linux-fsdevel BCC'ed ]

On Wed, Jun 19, 2013 at 12:48:26PM +0800, Younger Liu wrote:
> jbd2_journal_restart() would restart a handle. In this function, it
> calls start_this_handle(). Before calling start_this_handle()=EF=BC=8C=
subtract
> 1 from transaction->t_updates.
> If start_this_handle() succeeds, transaction->t_updates increases by =
1
> in it. But if start_this_handle() fails, transaction->t_updates does
> not increase.
> So, when commit the handle's transaction in jbd2_journal_stop(), the
> assertion is false, and then trigger a bug.
> The assertion is as follows:
> J_ASSERT(atomic_read(&transaction->t_updates) > 0)=20
>=20
> Signed-off-by: Younger Liu <younger.liu@huawei.com>

Thanks for pointing out this potential problem.  Your fix isn't quite
the right one, however.

The problem is once we get to this point, the transaction pointer may
no longer be valid, since once we decrement t_updates, the transaction
could start commiting, and so we should not actually dereference the
transaction pointer after we unlock transaction->t_handle_lock.  (We
are referencing t_tid two lines later, and technically that's a bug.
We've just been getting lucky.)

The real issue is that by the time we call start_this_handle() in
jbd2__journal_restart, the handle is not attached to any transaction.
So if jbd2_journal_restart() fails, the handle has to be considered
invalid, and the calling code should not try to use the handle at all,
including calling jbd2_journal_stop().

Jan Kara is I believe currently on vacation but I'd really like him to
chime in with his opinion about the best way to fix this, since he's
also quite familiar with the jbd2 code.

Also, Jan has recently submitted changes to implement reserved handles
(to be submitted in the next merge window), and in these new
functions, if start_this_handle() fails when called from
jbd2_journal_start_reserved(), the handle is left invalidated, and the
caller of jbd2_journal_start_reserved() must not touch the handle
again, including calling jbd2_journal_stop() --- in fact, because
jbd2_journal_start_reserved() clears current->journal_info on failure,
an attempt to call jbd2_journal_stop() will result in the kernel oops
due to an assertion failure.

My inclination is to fix this in the same way, but it will require
changing the current code paths that use jbd2_journal_restart(), and
in some cases passing back the state that the handle is now invalid
and should not be released via jbd2_journal_stop() is going to be
tricky indeed.


Another possible fix is to set the handle to be aborted, via
jbd2_journal_abort_handle().  This function isn't used at all at the
moment, but from what I can tell this should do the right thing.  The
one unfortunate thing about this is that when jbd2_journal_stop() gets
called, it will return EROFS, which is a misleading error code.  I'm
guessing you're seeing this because start_this_handle() returned
ENOMEM, correct?  We could hack around this by stashing the real error
in the handle, and then change jbd2_journal_stop() to return that
error instead of EROFS if it is set.

This second solution is hacky all-around, and it's also inconsistent
with how we are doing things with jbd2_journal_start_reserved().  So
I'm not so happy with this solution.  But it would require a lot less
work because the fix would be isolated in the jbd2 layer.  OTOH, right
now if the code calls jbd2_journal_stop() on the handle after a
failure in jbd2_journal_start_reserved(), they are crashing anyway, so
changing the code so it changes with an assertion failure doesn't make
things any worse, and then we fix things in ext4 and ocfs2 without any
patch interdependencies --- and this is a problem which appears to
happen very rarely in practice.

(How did you manage to trigger this, BTW?  Was this something you
noticed by manual code inspection?  Or are you instrumenting the
kernel's memory allocators to occasionally fail to test our error
paths?  Or were you running in a system with very heavy memory
pressure?)

						- Ted



> ---
>  fs/jbd2/transaction.c |    2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 325bc01..9ddb444 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -530,6 +530,8 @@ int jbd2__journal_restart(handle_t *handle, int n=
blocks, gfp_t gfp_mask)
>  	lock_map_release(&handle->h_lockdep_map);
>  	handle->h_buffer_credits =3D nblocks;
>  	ret =3D start_this_handle(journal, handle, gfp_mask);
> +	if (ret < 0)
> +		atomic_inc(&transaction->t_updates);
>  	return ret;
>  }
>  EXPORT_SYMBOL(jbd2__journal_restart);
> --=20
> 1.7.9.7
>=20
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
