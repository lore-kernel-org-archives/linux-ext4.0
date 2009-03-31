From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: next-20090310: ext4 hangs
Date: Tue, 31 Mar 2009 14:07:30 +0400
Message-ID: <a4423d670903310307i7acd31f0r4836beae14cfb92d@mail.gmail.com>
References: <a4423d670903110907o7041f4eof92278835aa0c71c@mail.gmail.com>
	 <20090325151516.GB14881@atrey.karlin.mff.cuni.cz>
	 <a4423d670903250818n512b1c67ja1b38db6d09ac7c@mail.gmail.com>
	 <20090325152234.GN23439@duck.suse.cz>
	 <a4423d670903250829w5e9304a7rce24f4220379620f@mail.gmail.com>
	 <20090325161556.GP23439@duck.suse.cz>
	 <a4423d670903251007r72058ca8m28275c1433ab2706@mail.gmail.com>
	 <20090325194316.GQ23439@duck.suse.cz>
	 <a4423d670903251538p3a7c180br1bcfe08c4f044c15@mail.gmail.com>
	 <20090331100150.GF11808@duck.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>,
	"linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
	linux-ext4@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	sparclinux@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20090331100150.GF11808@duck.suse.cz>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

2009/3/31 Jan Kara <jack@suse.cz>:
> On Thu 26-03-09 01:38:32, Alexander Beregalov wrote:
>> 2009/3/25 Jan Kara <jack@suse.cz>:
>> > On Wed 25-03-09 20:07:46, Alexander Beregalov wrote:
>> >> 2009/3/25 Jan Kara <jack@suse.cz>:
>> >> > On Wed 25-03-09 18:29:10, Alexander Beregalov wrote:
>> >> >> 2009/3/25 Jan Kara <jack@suse.cz>:
>> >> >> > On Wed 25-03-09 18:18:43, Alexander Beregalov wrote:
>> >> >> >> 2009/3/25 Jan Kara <jack@suse.cz>:
>> >> >> >> >> > So, I think I need to try it on 2.6.29-rc7 again.
>> >> >> >> >> =C2=A0 I've looked into this. Obviously, what's happenni=
ng is that we delete
>> >> >> >> >> an inode and jbd2_journal_release_jbd_inode() finds inod=
e is just under
>> >> >> >> >> writeout in transaction commit and thus it waits. But it=
 gets never woken
>> >> >> >> >> up and because it has a handle from the transaction, eve=
ry one eventually
>> >> >> >> >> blocks on waiting for a transaction to finish.
>> >> >> >> >> =C2=A0 But I don't really see how that can happen. The c=
ode is really
>> >> >> >> >> straightforward and everything happens under j_list_lock=
=2E.. Strange.
>> >> >> >> > =C2=A0BTW: Is the system SMP?
>> >> >> >> No, it is UP system.
>> >> >> > =C2=A0Even stranger. And do you have CONFIG_PREEMPT set?
>> >> >> >
>> >> >> >> The bug exists even in 2.6.29, I posted it with a new topic=
=2E
>> >> >> > =C2=A0OK, I've sort-of expected this.
>> >> >>
>> >> >> CONFIG_PREEMPT_RCU=3Dy
>> >> >> CONFIG_PREEMPT_RCU_TRACE=3Dy
>> >> >> # CONFIG_PREEMPT_NONE is not set
>> >> >> # CONFIG_PREEMPT_VOLUNTARY is not set
>> >> >> CONFIG_PREEMPT=3Dy
>> >> >> CONFIG_DEBUG_PREEMPT=3Dy
>> >> >> # CONFIG_PREEMPT_TRACER is not set
>> >> >>
>> >> >> config is attached.
>> >> > =C2=A0Thanks for the data. I still don't see how the wakeup can=
 get lost. The
>> >> > process even cannot be preempted when we are in the section pro=
tected by
>> >> > j_list_lock... Can you send me a disassembly of functions
>> >> > jbd2_journal_release_jbd_inode() and journal_submit_data_buffer=
s() so that
>> >> > I can see whether the compiler has not reordered something unex=
pectedly?
>> > =C2=A0Thanks for the disassembly...
>> >
>> >> By default gcc inlines journal_submit_data_buffers()
>> >> Here is -fno-inline version. Default version is in attach.
> =C2=A0<snip>
>
> =C2=A0I'm helpless here. I don't see how we can miss a wakeup (plus y=
ou seem to
> be the only one reporting the bug). Could you please compile and test=
 the kernel
> with the attached patch? It will print to kernel log when we go to sl=
eep
> waiting for inode commit and when we send wakeups etc. When you hit t=
he
> deadlock, please send me your kernel log. It should help with debuggi=
ng why do
> we miss the wakeup. Thanks.

Which patch?
