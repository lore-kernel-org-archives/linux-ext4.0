From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: next-20090310: ext4 hangs
Date: Thu, 26 Mar 2009 01:38:32 +0300
Message-ID: <a4423d670903251538p3a7c180br1bcfe08c4f044c15@mail.gmail.com>
References: <a4423d670903100718w1a532143he767782ae598d0fb@mail.gmail.com>
	 <a4423d670903110907o7041f4eof92278835aa0c71c@mail.gmail.com>
	 <20090325151122.GA14881@atrey.karlin.mff.cuni.cz>
	 <20090325151516.GB14881@atrey.karlin.mff.cuni.cz>
	 <a4423d670903250818n512b1c67ja1b38db6d09ac7c@mail.gmail.com>
	 <20090325152234.GN23439@duck.suse.cz>
	 <a4423d670903250829w5e9304a7rce24f4220379620f@mail.gmail.com>
	 <20090325161556.GP23439@duck.suse.cz>
	 <a4423d670903251007r72058ca8m28275c1433ab2706@mail.gmail.com>
	 <20090325194316.GQ23439@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	sparclinux@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090325194316.GQ23439@duck.suse.cz>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2009/3/25 Jan Kara <jack@suse.cz>:
> On Wed 25-03-09 20:07:46, Alexander Beregalov wrote:
>> 2009/3/25 Jan Kara <jack@suse.cz>:
>> > On Wed 25-03-09 18:29:10, Alexander Beregalov wrote:
>> >> 2009/3/25 Jan Kara <jack@suse.cz>:
>> >> > On Wed 25-03-09 18:18:43, Alexander Beregalov wrote:
>> >> >> 2009/3/25 Jan Kara <jack@suse.cz>:
>> >> >> >> > So, I think I need to try it on 2.6.29-rc7 again.
>> >> >> >> =C2=A0 I've looked into this. Obviously, what's happenning =
is that we delete
>> >> >> >> an inode and jbd2_journal_release_jbd_inode() finds inode i=
s just under
>> >> >> >> writeout in transaction commit and thus it waits. But it ge=
ts never woken
>> >> >> >> up and because it has a handle from the transaction, every =
one eventually
>> >> >> >> blocks on waiting for a transaction to finish.
>> >> >> >> =C2=A0 But I don't really see how that can happen. The code=
 is really
>> >> >> >> straightforward and everything happens under j_list_lock...=
 Strange.
>> >> >> > =C2=A0BTW: Is the system SMP?
>> >> >> No, it is UP system.
>> >> > =C2=A0Even stranger. And do you have CONFIG_PREEMPT set?
>> >> >
>> >> >> The bug exists even in 2.6.29, I posted it with a new topic.
>> >> > =C2=A0OK, I've sort-of expected this.
>> >>
>> >> CONFIG_PREEMPT_RCU=3Dy
>> >> CONFIG_PREEMPT_RCU_TRACE=3Dy
>> >> # CONFIG_PREEMPT_NONE is not set
>> >> # CONFIG_PREEMPT_VOLUNTARY is not set
>> >> CONFIG_PREEMPT=3Dy
>> >> CONFIG_DEBUG_PREEMPT=3Dy
>> >> # CONFIG_PREEMPT_TRACER is not set
>> >>
>> >> config is attached.
>> > =C2=A0Thanks for the data. I still don't see how the wakeup can ge=
t lost. The
>> > process even cannot be preempted when we are in the section protec=
ted by
>> > j_list_lock... Can you send me a disassembly of functions
>> > jbd2_journal_release_jbd_inode() and journal_submit_data_buffers()=
 so that
>> > I can see whether the compiler has not reordered something unexpec=
tedly?
> =C2=A0Thanks for the disassembly...
>
>> By default gcc inlines journal_submit_data_buffers()
>> Here is -fno-inline version. Default version is in attach.
>> =3D=3D=3D=3D
>>
>> static int journal_submit_data_buffers(journal_t *journal,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 transaction_=
t *commit_transaction)
>> {
>> =C2=A0 =C2=A0 =C2=A0 9c: =C2=A0 =C2=A0 =C2=A0 9d e3 bf 40 =C2=A0 =C2=
=A0 save =C2=A0%sp, -192, %sp
>> =C2=A0 =C2=A0 =C2=A0 a0: =C2=A0 =C2=A0 =C2=A0 11 00 00 00 =C2=A0 =C2=
=A0 sethi =C2=A0%hi(0), %o0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct jbd2_inode *jinode;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 int err, ret =3D 0;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct address_space *mapping;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&journal->j_list_lock);
>> =C2=A0 =C2=A0 =C2=A0 a4: =C2=A0 =C2=A0 =C2=A0 a4 06 25 70 =C2=A0 =C2=
=A0 add =C2=A0%i0, 0x570, %l2
>> =C2=A0* our inode list. We use JI_COMMIT_RUNNING flag to protect ino=
de we currently
>> =C2=A0* operate on from being released while we write out pages.
>> =C2=A0*/
>> static int journal_submit_data_buffers(journal_t *journal,
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 transaction_=
t *commit_transaction)
>> {
>> =C2=A0 =C2=A0 =C2=A0 a8: =C2=A0 =C2=A0 =C2=A0 90 12 20 00 =C2=A0 =C2=
=A0 mov =C2=A0%o0, %o0
>> =C2=A0 =C2=A0 =C2=A0 ac: =C2=A0 =C2=A0 =C2=A0 40 00 00 00 =C2=A0 =C2=
=A0 call =C2=A0ac <journal_submit_data_buffers+0x10>
>> =C2=A0 =C2=A0 =C2=A0 b0: =C2=A0 =C2=A0 =C2=A0 b0 10 20 00 =C2=A0 =C2=
=A0 clr =C2=A0%i0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct jbd2_inode *jinode;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 int err, ret =3D 0;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct address_space *mapping;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&journal->j_list_lock);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_for_each_entry(jinode, &commit_tran=
saction->t_inode_list, i_list) {
>> =C2=A0 =C2=A0 =C2=A0 b4: =C2=A0 =C2=A0 =C2=A0 a6 06 60 60 =C2=A0 =C2=
=A0 add =C2=A0%i1, 0x60, %l3
>> {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct jbd2_inode *jinode;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 int err, ret =3D 0;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct address_space *mapping;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&journal->j_list_lock);
>> =C2=A0 =C2=A0 =C2=A0 b8: =C2=A0 =C2=A0 =C2=A0 40 00 00 00 =C2=A0 =C2=
=A0 call =C2=A0b8 <journal_submit_data_buffers+0x1c>
>> =C2=A0 =C2=A0 =C2=A0 bc: =C2=A0 =C2=A0 =C2=A0 90 10 00 12 =C2=A0 =C2=
=A0 mov =C2=A0%l2, %o0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_for_each_entry(jinode, &commit_tran=
saction->t_inode_list, i_list) {
>> =C2=A0 =C2=A0 =C2=A0 c0: =C2=A0 =C2=A0 =C2=A0 10 68 00 1d =C2=A0 =C2=
=A0 b =C2=A0%xcc, 134 <journal_submit_data_buffers+0x98>
>> =C2=A0 =C2=A0 =C2=A0 c4: =C2=A0 =C2=A0 =C2=A0 c2 5e 60 60 =C2=A0 =C2=
=A0 ldx =C2=A0[ %i1 + 0x60 ], %g1
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mapping =3D =
jinode->i_vfs_inode->i_mapping;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 jinode->i_fl=
ags |=3D JI_COMMIT_RUNNING;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(=
&journal->j_list_lock);
>> =C2=A0 =C2=A0 =C2=A0 c8: =C2=A0 =C2=A0 =C2=A0 90 10 00 12 =C2=A0 =C2=
=A0 mov =C2=A0%l2, %o0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct address_space *mapping;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&journal->j_list_lock);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_for_each_entry(jinode, &commit_tran=
saction->t_inode_list, i_list) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mapping =3D =
jinode->i_vfs_inode->i_mapping;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 jinode->i_fl=
ags |=3D JI_COMMIT_RUNNING;
>> =C2=A0 =C2=A0 =C2=A0 cc: =C2=A0 =C2=A0 =C2=A0 c2 04 60 28 =C2=A0 =C2=
=A0 ld =C2=A0[ %l1 + 0x28 ], %g1
> =C2=A0Here we load jbd2_inode->i_flags into %g1.
>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 int err, ret =3D 0;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct address_space *mapping;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&journal->j_list_lock);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_for_each_entry(jinode, &commit_tran=
saction->t_inode_list, i_list) {
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 mapping =3D =
jinode->i_vfs_inode->i_mapping;
>> =C2=A0 =C2=A0 =C2=A0 d0: =C2=A0 =C2=A0 =C2=A0 e0 58 a1 e0 =C2=A0 =C2=
=A0 ldx =C2=A0[ %g2 + 0x1e0 ], %l0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 jinode->i_fl=
ags |=3D JI_COMMIT_RUNNING;
>> =C2=A0 =C2=A0 =C2=A0 d4: =C2=A0 =C2=A0 =C2=A0 82 10 60 01 =C2=A0 =C2=
=A0 or =C2=A0%g1, 1, %g1
> =C2=A0Here we set JI_COMMIT_RUNNING.
>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(=
&journal->j_list_lock);
>> =C2=A0 =C2=A0 =C2=A0 d8: =C2=A0 =C2=A0 =C2=A0 40 00 00 00 =C2=A0 =C2=
=A0 call =C2=A0d8 <journal_submit_data_buffers+0x3c>
> =C2=A0Here we seem to call preempt_disable() (it would be useful if w=
e could
> confirm that - easiest option I know is compiling JBD2 into a kernel =
but
> some object file trickery should be able to find it out as well...)
  55bab0:       82 10 60 01     or  %g1, 1, %g1
                spin_unlock(&journal->j_list_lock);
  55bab4:       40 06 4b 20     call  6ee734 <_spin_unlock>
  55bab8:       c2 24 e0 28     st  %g1, [ %l3 + 0x28 ]
<..>
void __lockfunc _spin_unlock(spinlock_t *lock)
{
  6ee734:       9d e3 bf 40     save  %sp, -192, %sp
  6ee738:       11 00 1f f9     sethi  %hi(0x7fe400), %o0
  6ee73c:       7f fb 36 59     call  5bc0a0 <_mcount>
  6ee740:       90 12 22 40     or  %o0, 0x240, %o0     ! 7fe640
<rt_trace_on+0xc8>
        spin_release(&lock->dep_map, 1, _RET_IP_);
  6ee744:       94 10 00 1f     mov  %i7, %o2
  6ee748:       92 10 20 01     mov  1, %o1
  6ee74c:       7f f6 21 18     call  476bac <lock_release>
  6ee750:       90 06 20 18     add  %i0, 0x18, %o0
        _raw_spin_unlock(lock);
  6ee754:       7f fb 7f 91     call  5ce598 <_raw_spin_unlock>
  6ee758:       90 10 00 18     mov  %i0, %o0
        preempt_enable();
  6ee75c:       40 00 05 fd     call  6eff50 <sub_preempt_count>
  6ee760:       90 10 20 01     mov  1, %o0
  6ee764:       c2 59 a0 08     ldx  [ %g6 + 8 ], %g1
  6ee768:       82 08 60 08     and  %g1, 8, %g1
  6ee76c:       02 c8 40 04     brz  %g1, 6ee77c <_spin_unlock+0x48>
  6ee770:       01 00 00 00     nop
  6ee774:       7f ff f4 f1     call  6ebb38 <preempt_schedule>
  6ee778:       01 00 00 00     nop
  6ee77c:       81 cf e0 08     rett  %i7 + 8
  6ee780:       01 00 00 00     nop
}


>
>> =C2=A0 =C2=A0 =C2=A0 dc: =C2=A0 =C2=A0 =C2=A0 c2 24 60 28 =C2=A0 =C2=
=A0 st =C2=A0%g1, [ %l1 + 0x28 ]
> =C2=A0And here we store the register back to memory - but we could be=
 already
> preempted here which could cause bugs...
>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* subm=
it the inode data buffers. We use writepage
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* inst=
ead of writepages. Because writepages can do
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* bloc=
k allocation =C2=A0with delalloc. We need to write
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* only=
 allocated blocks here.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D jour=
nal_submit_inode_data_buffers(mapping);
>> =C2=A0 =C2=A0 =C2=A0 e0: =C2=A0 =C2=A0 =C2=A0 7f ff ff d3 =C2=A0 =C2=
=A0 call =C2=A02c <journal_submit_inode_data_buffers>
>> =C2=A0 =C2=A0 =C2=A0 e4: =C2=A0 =C2=A0 =C2=A0 90 10 00 10 =C2=A0 =C2=
=A0 mov =C2=A0%l0, %o0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!ret)
>> =C2=A0 =C2=A0 =C2=A0 e8: =C2=A0 =C2=A0 =C2=A0 80 a6 20 00 =C2=A0 =C2=
=A0 cmp =C2=A0%i0, 0
>> =C2=A0 =C2=A0 =C2=A0 ec: =C2=A0 =C2=A0 =C2=A0 b1 64 40 08 =C2=A0 =C2=
=A0 move =C2=A0%icc, %o0, %i0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 ret =3D err;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&j=
ournal->j_list_lock);
>> =C2=A0 =C2=A0 =C2=A0 f0: =C2=A0 =C2=A0 =C2=A0 40 00 00 00 =C2=A0 =C2=
=A0 call =C2=A0f0 <journal_submit_data_buffers+0x54>
>> =C2=A0 =C2=A0 =C2=A0 f4: =C2=A0 =C2=A0 =C2=A0 90 10 00 12 =C2=A0 =C2=
=A0 mov =C2=A0%l2, %o0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 J_ASSERT(jin=
ode->i_transaction =3D=3D commit_transaction);
>> =C2=A0 =C2=A0 =C2=A0 f8: =C2=A0 =C2=A0 =C2=A0 c2 5c 40 00 =C2=A0 =C2=
=A0 ldx =C2=A0[ %l1 ], %g1
>> =C2=A0 =C2=A0 =C2=A0 fc: =C2=A0 =C2=A0 =C2=A0 80 a0 40 19 =C2=A0 =C2=
=A0 cmp =C2=A0%g1, %i1
>> =C2=A0 =C2=A0 =C2=A0100: =C2=A0 =C2=A0 =C2=A0 22 68 00 07 =C2=A0 =C2=
=A0 be,a =C2=A0 %xcc, 11c
>> <journal_submit_data_buffers+0x80>
>> =C2=A0 =C2=A0 =C2=A0104: =C2=A0 =C2=A0 =C2=A0 c2 04 60 28 =C2=A0 =C2=
=A0 ld =C2=A0[ %l1 + 0x28 ], %g1
> =C2=A0Again, here we load jinode->i_flags.
>
>> =C2=A0 =C2=A0 =C2=A0108: =C2=A0 =C2=A0 =C2=A0 11 00 00 00 =C2=A0 =C2=
=A0 sethi =C2=A0%hi(0), %o0
>> =C2=A0 =C2=A0 =C2=A010c: =C2=A0 =C2=A0 =C2=A0 92 10 21 04 =C2=A0 =C2=
=A0 mov =C2=A00x104, %o1
>> =C2=A0 =C2=A0 =C2=A0110: =C2=A0 =C2=A0 =C2=A0 40 00 00 00 =C2=A0 =C2=
=A0 call =C2=A0110 <journal_submit_data_buffers+0x74>
>> =C2=A0 =C2=A0 =C2=A0114: =C2=A0 =C2=A0 =C2=A0 90 12 20 00 =C2=A0 =C2=
=A0 mov =C2=A0%o0, %o0
>> =C2=A0 =C2=A0 =C2=A0118: =C2=A0 =C2=A0 =C2=A0 91 d0 20 05 =C2=A0 =C2=
=A0 ta =C2=A05
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 jinode->i_fl=
ags &=3D ~JI_COMMIT_RUNNING;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wake_up_bit(=
&jinode->i_flags, __JI_COMMIT_RUNNING);
>> =C2=A0 =C2=A0 =C2=A011c: =C2=A0 =C2=A0 =C2=A0 90 04 60 28 =C2=A0 =C2=
=A0 add =C2=A0%l1, 0x28, %o0
>> =C2=A0 =C2=A0 =C2=A0120: =C2=A0 =C2=A0 =C2=A0 92 10 20 00 =C2=A0 =C2=
=A0 clr =C2=A0%o1
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 err =3D jour=
nal_submit_inode_data_buffers(mapping);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!ret)
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 ret =3D err;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&j=
ournal->j_list_lock);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 J_ASSERT(jin=
ode->i_transaction =3D=3D commit_transaction);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 jinode->i_fl=
ags &=3D ~JI_COMMIT_RUNNING;
>> =C2=A0 =C2=A0 =C2=A0124: =C2=A0 =C2=A0 =C2=A0 82 08 7f fe =C2=A0 =C2=
=A0 and =C2=A0%g1, -2, %g1
> =C2=A0Here we go &=3D ~JI_COMMIT_RUNNING
>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wake_up_bit(=
&jinode->i_flags, __JI_COMMIT_RUNNING);
>> =C2=A0 =C2=A0 =C2=A0128: =C2=A0 =C2=A0 =C2=A0 40 00 00 00 =C2=A0 =C2=
=A0 call =C2=A0128 <journal_submit_data_buffers+0x8c>
>> =C2=A0 =C2=A0 =C2=A012c: =C2=A0 =C2=A0 =C2=A0 c2 24 60 28 =C2=A0 =C2=
=A0 st =C2=A0%g1, [ %l1 + 0x28 ]
> =C2=A0And only here we store it back to memory...

                spin_lock(&journal->j_list_lock);
  55c104:       40 06 48 3c     call  6ee1f4 <_spin_lock>
  55c108:       90 10 00 12     mov  %l2, %o0
                jinode->i_flags &=3D ~JI_COMMIT_RUNNING;
  55c10c:       c2 04 20 28     ld  [ %l0 + 0x28 ], %g1
                wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
  55c110:       90 04 20 28     add  %l0, 0x28, %o0
  55c114:       92 10 20 00     clr  %o1
                        if (!ret)
                                ret =3D err;
                }
                spin_lock(&journal->j_list_lock);
                jinode->i_flags &=3D ~JI_COMMIT_RUNNING;
  55c118:       82 08 7f fe     and  %g1, -2, %g1
                wake_up_bit(&jinode->i_flags, __JI_COMMIT_RUNNING);
  55c11c:       7f fc 27 6e     call  465ed4 <wake_up_bit>
  55c120:       c2 24 20 28     st  %g1, [ %l0 + 0x28 ]
<..>
void __lockfunc _spin_lock(spinlock_t *lock)
{
  6ee1f4:       9d e3 bf 30     save  %sp, -208, %sp
  6ee1f8:       11 00 1f f9     sethi  %hi(0x7fe400), %o0
  6ee1fc:       7f fb 37 a9     call  5bc0a0 <_mcount>
  6ee200:       90 12 21 c8     or  %o0, 0x1c8, %o0     ! 7fe5c8
<rt_trace_on+0x50>
        preempt_disable();
  6ee204:       40 00 07 83     call  6f0010 <add_preempt_count>
  6ee208:       90 10 20 01     mov  1, %o0
        spin_acquire(&lock->dep_map, 0, 0, _RET_IP_);
  6ee20c:       92 10 20 00     clr  %o1
  6ee210:       90 06 20 18     add  %i0, 0x18, %o0
  6ee214:       fe 73 a8 af     stx  %i7, [ %sp + 0x8af ]
  6ee218:       94 10 20 00     clr  %o2
  6ee21c:       96 10 20 00     clr  %o3
  6ee220:       98 10 20 02     mov  2, %o4
  6ee224:       7f f6 21 a5     call  4768b8 <lock_acquire>
  6ee228:       9a 10 20 00     clr  %o5
        LOCK_CONTENDED(lock, _raw_spin_trylock, _raw_spin_lock);
  6ee22c:       7f fb 81 33     call  5ce6f8 <_raw_spin_lock>
  6ee230:       90 10 00 18     mov  %i0, %o0
}
  6ee234:       81 cf e0 08     rett  %i7 + 8
  6ee238:       01 00 00 00     nop
<..>
void wake_up_bit(void *word, int bit)
{
  465ed4:       9d e3 bf 40     save  %sp, -192, %sp
  465ed8:       11 00 1f f2     sethi  %hi(0x7fc800), %o0
  465edc:       40 05 58 71     call  5bc0a0 <_mcount>
  465ee0:       90 12 23 c8     or  %o0, 0x3c8, %o0     ! 7fcbc8
<kthread_stop_lock+0x88>
        __wake_up_bit(bit_waitqueue(word, bit), word, bit);
  465ee4:       92 10 00 19     mov  %i1, %o1
  465ee8:       7f ff ff c5     call  465dfc <bit_waitqueue>
  465eec:       90 10 00 18     mov  %i0, %o0
  465ef0:       92 10 00 18     mov  %i0, %o1
  465ef4:       7f ff ff e7     call  465e90 <__wake_up_bit>
  465ef8:       94 10 00 19     mov  %i1, %o2
}
  465efc:       81 cf e0 08     rett  %i7 + 8
  465f00:       01 00 00 00     nop


>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct jbd2_inode *jinode;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 int err, ret =3D 0;
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct address_space *mapping;
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&journal->j_list_lock);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 list_for_each_entry(jinode, &commit_tran=
saction->t_inode_list, i_list) {
>> =C2=A0 =C2=A0 =C2=A0130: =C2=A0 =C2=A0 =C2=A0 c2 5c 60 10 =C2=A0 =C2=
=A0 ldx =C2=A0[ %l1 + 0x10 ], %g1
>> =C2=A0 =C2=A0 =C2=A0134: =C2=A0 =C2=A0 =C2=A0 a2 00 7f f0 =C2=A0 =C2=
=A0 add =C2=A0%g1, -16, %l1
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* prefetches into the prefetch-cac=
he which only is accessible
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* by floating point operations in =
UltraSPARC-III and later.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* By contrast, "#one_write" prefet=
ches into the L2 cache
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0* in shared state.
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*/
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 __asm__ __volatile__("prefetch [%0], #on=
e_write"
>> =C2=A0 =C2=A0 =C2=A0138: =C2=A0 =C2=A0 =C2=A0 c2 5c 60 10 =C2=A0 =C2=
=A0 ldx =C2=A0[ %l1 + 0x10 ], %g1
>> =C2=A0 =C2=A0 =C2=A013c: =C2=A0 =C2=A0 =C2=A0 c7 68 40 00 =C2=A0 =C2=
=A0 prefetch =C2=A0[ %g1 ], #one_write
>> =C2=A0 =C2=A0 =C2=A0140: =C2=A0 =C2=A0 =C2=A0 82 04 60 10 =C2=A0 =C2=
=A0 add =C2=A0%l1, 0x10, %g1
>> =C2=A0 =C2=A0 =C2=A0144: =C2=A0 =C2=A0 =C2=A0 80 a4 c0 01 =C2=A0 =C2=
=A0 cmp =C2=A0%l3, %g1
>> =C2=A0 =C2=A0 =C2=A0148: =C2=A0 =C2=A0 =C2=A0 32 6f ff e0 =C2=A0 =C2=
=A0 bne,a =C2=A0 %xcc, c8
>> <journal_submit_data_buffers+0x2c>
>> =C2=A0 =C2=A0 =C2=A014c: =C2=A0 =C2=A0 =C2=A0 c4 5c 60 20 =C2=A0 =C2=
=A0 ldx =C2=A0[ %l1 + 0x20 ], %g2
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(&j=
ournal->j_list_lock);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 J_ASSERT(jin=
ode->i_transaction =3D=3D commit_transaction);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 wake_up_bit(=
&jinode->i_flags, __JI_COMMIT_RUNNING);
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 }
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(&journal->j_list_lock);
>> =C2=A0 =C2=A0 =C2=A0150: =C2=A0 =C2=A0 =C2=A0 90 10 00 12 =C2=A0 =C2=
=A0 mov =C2=A0%l2, %o0
>> =C2=A0 =C2=A0 =C2=A0154: =C2=A0 =C2=A0 =C2=A0 40 00 00 00 =C2=A0 =C2=
=A0 call =C2=A0154 <journal_submit_data_buffers+0xb8>
>> =C2=A0 =C2=A0 =C2=A0158: =C2=A0 =C2=A0 =C2=A0 b1 3e 20 00 =C2=A0 =C2=
=A0 sra =C2=A0%i0, 0, %i0
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 return ret;
>> }
>> =C2=A0 =C2=A0 =C2=A015c: =C2=A0 =C2=A0 =C2=A0 81 cf e0 08 =C2=A0 =C2=
=A0 rett =C2=A0%i7 + 8
>> =C2=A0 =C2=A0 =C2=A0160: =C2=A0 =C2=A0 =C2=A0 01 00 00 00 =C2=A0 =C2=
=A0 nop
> =C2=A0So the compiled code looks a bit suspitious to me. Having the d=
isassembly
> with symbols properly resolved would help confirm it. I'm adding spar=
c list
> to CC just in case someone sees the problem...
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>
