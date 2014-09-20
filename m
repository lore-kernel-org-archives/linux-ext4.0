From: Fabian Frederick <fabf@skynet.be>
Subject: Re: [PATCH 1/1 linux-next] jbd2: Fix sparse context imbalance
 warning
Date: Sat, 20 Sep 2014 09:14:11 +0200 (CEST)
Message-ID: <1623224162.140196.1411197251348.open-xchange@webmail.nmp.skynet.be>
References: <1411064974-18304-1-git-send-email-fabf@skynet.be> <20140918204455.GA26995@thunk.org>
Reply-To: Fabian Frederick <fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140918204455.GA26995@thunk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org



> On 18 September 2014 at 22:44 Theodore Ts'o <tytso@mit.edu> wrote:
>
>
> On Thu, Sep 18, 2014 at 08:29:34PM +0200, Fabian Frederick wrote:
> > spin_unlock after spin_lock only.
> >
> > This fixes the following sparse warning:
> > fs/jbd2/transaction.c:1102:20: warning: context imbalance
> > in 'jbd2_journal_get_create_access' - different lock contexts for b=
asic
> > block
> >
> > Signed-off-by: Fabian Frederick <fabf@skynet.be>
>
> NAK, this is a case where I think it's better to make the static
> analyzers better.=C2=A0 In any case sparse gives a lot of false posit=
ives
> for this particular warning, so adding lines of code to try to shut u=
p
> sparse for every single false positive seems to be a losing
> proposition.
>
> I'll note that these sorts of bugs are much more easily picked up
> using lockdep in any case, so we're probably better of just ignoring
> these sorts of warnings.=C2=A0 Better to let the 0day kernel tester w=
arn
> for new sparse warnings, instead of trying to drive sparse warnings
> down to zero.
>
> Cheers,
>
>=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0- =
Ted

Thanks a lot for explanation Ted. I didn't see J_ASSERT_JH above which =
BUG_ON
if b_transaction is not ok.


Regards,
=46abian
