From: Jan Kara <jack@suse.cz>
Subject: Re: next-20090310: ext4 hangs
Date: Wed, 25 Mar 2009 20:43:17 +0100
Message-ID: <20090325194316.GQ23439@duck.suse.cz>
References: <a4423d670903100718w1a532143he767782ae598d0fb@mail.gmail.com> <20090310154745.GF23075@mit.edu> <a4423d670903110907o7041f4eof92278835aa0c71c@mail.gmail.com> <20090325151122.GA14881@atrey.karlin.mff.cuni.cz> <20090325151516.GB14881@atrey.karlin.mff.cuni.cz> <a4423d670903250818n512b1c67ja1b38db6d09ac7c@mail.gmail.com> <20090325152234.GN23439@duck.suse.cz> <a4423d670903250829w5e9304a7rce24f4220379620f@mail.gmail.com> <20090325161556.GP23439@duck.suse.cz> <a4423d670903251007r72058ca8m28275c1433ab2706@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	sparclinux@vger.kernel.org
To: Alexander Beregalov <a.beregalov@gmail.com>
Return-path: <sparclinux-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a4423d670903251007r72058ca8m28275c1433ab2706@mail.gmail.com>
Sender: sparclinux-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed 25-03-09 20:07:46, Alexander Beregalov wrote:
> 2009/3/25 Jan Kara <jack@suse.cz>:
> > On Wed 25-03-09 18:29:10, Alexander Beregalov wrote:
> >> 2009/3/25 Jan Kara <jack@suse.cz>:
> >> > On Wed 25-03-09 18:18:43, Alexander Beregalov wrote:
> >> >> 2009/3/25 Jan Kara <jack@suse.cz>:
> >> >> >> > So, I think I need to try it on 2.6.29-rc7 again.
> >> >> >> =A0 I've looked into this. Obviously, what's happenning is t=
hat we delete
> >> >> >> an inode and jbd2_journal_release_jbd_inode() finds inode is=
 just under
> >> >> >> writeout in transaction commit and thus it waits. But it get=
s never woken
> >> >> >> up and because it has a handle from the transaction, every o=
ne eventually
> >> >> >> blocks on waiting for a transaction to finish.
> >> >> >> =A0 But I don't really see how that can happen. The code is =
really
> >> >> >> straightforward and everything happens under j_list_lock... =
Strange.
> >> >> > =A0BTW: Is the system SMP?
> >> >> No, it is UP system.
> >> > =A0Even stranger. And do you have CONFIG_PREEMPT set?
> >> >
> >> >> The bug exists even in 2.6.29, I posted it with a new topic.
> >> > =A0OK, I've sort-of expected this.
> >>
> >> CONFIG_PREEMPT_RCU=3Dy
> >> CONFIG_PREEMPT_RCU_TRACE=3Dy
> >> # CONFIG_PREEMPT_NONE is not set
> >> # CONFIG_PREEMPT_VOLUNTARY is not set
> >> CONFIG_PREEMPT=3Dy
> >> CONFIG_DEBUG_PREEMPT=3Dy
> >> # CONFIG_PREEMPT_TRACER is not set
> >>
> >> config is attached.
> > =A0Thanks for the data. I still don't see how the wakeup can get lo=
st. The
> > process even cannot be preempted when we are in the section protect=
ed by
> > j_list_lock... Can you send me a disassembly of functions
> > jbd2_journal_release_jbd_inode() and journal_submit_data_buffers() =
so that
> > I can see whether the compiler has not reordered something unexpect=
edly?
  Thanks for the disassembly...

> By default gcc inlines journal_submit_data_buffers()
> Here is -fno-inline version. Default version is in attach.
> =3D=3D=3D=3D
>=20
> static int journal_submit_data_buffers(journal_t *journal,
>                 transaction_t *commit_transaction)
> {
>       9c:       9d e3 bf 40     save  %sp, -192, %sp
>       a0:       11 00 00 00     sethi  %hi(0), %o0
>         struct jbd2_inode *jinode;
>         int err, ret =3D 0;
>         struct address_space *mapping;
>=20
>         spin_lock(&journal->j_list_lock);
>       a4:       a4 06 25 70     add  %i0, 0x570, %l2
>  * our inode list. We use JI_COMMIT_RUNNING flag to protect inode we =
currently
>  * operate on from being released while we write out pages.
>  */
> static int journal_submit_data_buffers(journal_t *journal,
>                 transaction_t *commit_transaction)
> {
>       a8:       90 12 20 00     mov  %o0, %o0
>       ac:       40 00 00 00     call  ac <journal_submit_data_buffers=
+0x10>
>       b0:       b0 10 20 00     clr  %i0
>         struct jbd2_inode *jinode;
>         int err, ret =3D 0;
>         struct address_space *mapping;
>=20
>         spin_lock(&journal->j_list_lock);
>         list_for_each_entry(jinode, &commit_transaction->t_inode_list=
, i_list) {
>       b4:       a6 06 60 60     add  %i1, 0x60, %l3
> {
>         struct jbd2_inode *jinode;
>         int err, ret =3D 0;
>         struct address_space *mapping;
>=20
>         spin_lock(&journal->j_list_lock);
>       b8:       40 00 00 00     call  b8 <journal_submit_data_buffers=
+0x1c>
>       bc:       90 10 00 12     mov  %l2, %o0
>         list_for_each_entry(jinode, &commit_transaction->t_inode_list=
, i_list) {
>       c0:       10 68 00 1d     b  %xcc, 134 <journal_submit_data_buf=
fers+0x98>
>       c4:       c2 5e 60 60     ldx  [ %i1 + 0x60 ], %g1
>                 mapping =3D jinode->i_vfs_inode->i_mapping;
>                 jinode->i_flags |=3D JI_COMMIT_RUNNING;
>                 spin_unlock(&journal->j_list_lock);
>       c8:       90 10 00 12     mov  %l2, %o0
>         struct address_space *mapping;
>=20
>         spin_lock(&journal->j_list_lock);
>         list_for_each_entry(jinode, &commit_transaction->t_inode_list=
, i_list) {
>                 mapping =3D jinode->i_vfs_inode->i_mapping;
>                 jinode->i_flags |=3D JI_COMMIT_RUNNING;
>       cc:       c2 04 60 28     ld  [ %l1 + 0x28 ], %g1
  Here we load jbd2_inode->i_flags into %g1.

>         int err, ret =3D 0;
>         struct address_space *mapping;
>=20
>         spin_lock(&journal->j_list_lock);
>         list_for_each_entry(jinode, &commit_transaction->t_inode_list=
, i_list) {
>                 mapping =3D jinode->i_vfs_inode->i_mapping;
>       d0:       e0 58 a1 e0     ldx  [ %g2 + 0x1e0 ], %l0
>                 jinode->i_flags |=3D JI_COMMIT_RUNNING;
>       d4:       82 10 60 01     or  %g1, 1, %g1
  Here we set JI_COMMIT_RUNNING.

>                 spin_unlock(&journal->j_list_lock);
>       d8:       40 00 00 00     call  d8 <journal_submit_data_buffers=
+0x3c>
  Here we seem to call preempt_disable() (it would be useful if we coul=
d
confirm that - easiest option I know is compiling JBD2 into a kernel bu=
t
some object file trickery should be able to find it out as well...)

>       dc:       c2 24 60 28     st  %g1, [ %l1 + 0x28 ]
  And here we store the register back to memory - but we could be alrea=
dy
preempted here which could cause bugs...

>                  * submit the inode data buffers. We use writepage
>                  * instead of writepages. Because writepages can do
>                  * block allocation  with delalloc. We need to write
>                  * only allocated blocks here.
>                  */
>                 err =3D journal_submit_inode_data_buffers(mapping);
>       e0:       7f ff ff d3     call  2c <journal_submit_inode_data_b=
uffers>
>       e4:       90 10 00 10     mov  %l0, %o0
>                 if (!ret)
>       e8:       80 a6 20 00     cmp  %i0, 0
>       ec:       b1 64 40 08     move  %icc, %o0, %i0
>                         ret =3D err;
>                 spin_lock(&journal->j_list_lock);
>       f0:       40 00 00 00     call  f0 <journal_submit_data_buffers=
+0x54>
>       f4:       90 10 00 12     mov  %l2, %o0
>                 J_ASSERT(jinode->i_transaction =3D=3D commit_transact=
ion);
>       f8:       c2 5c 40 00     ldx  [ %l1 ], %g1
>       fc:       80 a0 40 19     cmp  %g1, %i1
>      100:       22 68 00 07     be,a   %xcc, 11c
> <journal_submit_data_buffers+0x80>
>      104:       c2 04 60 28     ld  [ %l1 + 0x28 ], %g1
  Again, here we load jinode->i_flags.

>      108:       11 00 00 00     sethi  %hi(0), %o0
>      10c:       92 10 21 04     mov  0x104, %o1
>      110:       40 00 00 00     call  110 <journal_submit_data_buffer=
s+0x74>
>      114:       90 12 20 00     mov  %o0, %o0
>      118:       91 d0 20 05     ta  5
>                 jinode->i_flags &=3D ~JI_COMMIT_RUNNING;
>                 wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
>      11c:       90 04 60 28     add  %l1, 0x28, %o0
>      120:       92 10 20 00     clr  %o1
>                 err =3D journal_submit_inode_data_buffers(mapping);
>                 if (!ret)
>                         ret =3D err;
>                 spin_lock(&journal->j_list_lock);
>                 J_ASSERT(jinode->i_transaction =3D=3D commit_transact=
ion);
>                 jinode->i_flags &=3D ~JI_COMMIT_RUNNING;
>      124:       82 08 7f fe     and  %g1, -2, %g1
  Here we go &=3D ~JI_COMMIT_RUNNING

>                 wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
>      128:       40 00 00 00     call  128 <journal_submit_data_buffer=
s+0x8c>
>      12c:       c2 24 60 28     st  %g1, [ %l1 + 0x28 ]
  And only here we store it back to memory...

>         struct jbd2_inode *jinode;
>         int err, ret =3D 0;
>         struct address_space *mapping;
>=20
>         spin_lock(&journal->j_list_lock);
>         list_for_each_entry(jinode, &commit_transaction->t_inode_list=
, i_list) {
>      130:       c2 5c 60 10     ldx  [ %l1 + 0x10 ], %g1
>      134:       a2 00 7f f0     add  %g1, -16, %l1
>          * prefetches into the prefetch-cache which only is accessibl=
e
>          * by floating point operations in UltraSPARC-III and later.
>          * By contrast, "#one_write" prefetches into the L2 cache
>          * in shared state.
>          */
>         __asm__ __volatile__("prefetch [%0], #one_write"
>      138:       c2 5c 60 10     ldx  [ %l1 + 0x10 ], %g1
>      13c:       c7 68 40 00     prefetch  [ %g1 ], #one_write
>      140:       82 04 60 10     add  %l1, 0x10, %g1
>      144:       80 a4 c0 01     cmp  %l3, %g1
>      148:       32 6f ff e0     bne,a   %xcc, c8
> <journal_submit_data_buffers+0x2c>
>      14c:       c4 5c 60 20     ldx  [ %l1 + 0x20 ], %g2
>                 spin_lock(&journal->j_list_lock);
>                 J_ASSERT(jinode->i_transaction =3D=3D commit_transact=
ion);
>                 wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
>         }
>         spin_unlock(&journal->j_list_lock);
>      150:       90 10 00 12     mov  %l2, %o0
>      154:       40 00 00 00     call  154 <journal_submit_data_buffer=
s+0xb8>
>      158:       b1 3e 20 00     sra  %i0, 0, %i0
>         return ret;
> }
>      15c:       81 cf e0 08     rett  %i7 + 8
>      160:       01 00 00 00     nop
  So the compiled code looks a bit suspitious to me. Having the disasse=
mbly
with symbols properly resolved would help confirm it. I'm adding sparc =
list
to CC just in case someone sees the problem...

									Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe sparclinux" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
