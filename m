From: Chris Worley <worleys@gmail.com>
Subject: Re: Is TRIM/DISCARD going to be a performance problem?
Date: Mon, 11 May 2009 16:03:38 -0600
Message-ID: <f3177b9e0905111503l1f8f8708u7fe95c34ff74f10a@mail.gmail.com>
References: <E1M2ts6-0005jr-Cg@closure.thunk.org>
	 <20090510165259.GA31850@logfs.org> <20090511083754.GA29082@mit.edu>
	 <20090511100624.GB6585@logfs.org> <20090511112729.GD29082@mit.edu>
	 <20090511124325.GC6585@logfs.org>
	 <20090511124822.GD8112@parisc-linux.org>
	 <f3177b9e0905111433i40e41c90r920d7ccf36442ffd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <f3177b9e0905111433i40e41c90r920d7ccf36442ffd@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

 On Mon, May 11, 2009 at 6:48 AM, Matthew Wilcox <matthew@wil.cx> wrote=
:
>
> On Mon, May 11, 2009 at 02:43:25PM +0200, J??rn Engel wrote:
> > Given the hardware braindamage it is relatively sane. =A0As always,=
 it
> > would be much better to fix the problem and not add workarounds, bu=
t we
> > seem to lack the gods favor this time around.
> >
> > Can't anyone explain to the SATA folks that a discard is much close=
r to
> > a write than to a secure erase or some other rare and slow command?
>
> I've heard the ATA committee are working on an NCQ version of TRIM.

Doesn't this fact make this discussion moot?

If the ATA committee knows they've got a problem, and are fixing it at
the level where the problem exists, why is Linux's job to fix at a
higher level?

The proposed solutions are going to consume CPU and slow down I/O
unnecessarily, as well as inefficiently dispatch Discards (i.e. the
longer the time between the discard and the reuse of a block, the
better).=A0 If they are going to be implemented, then have a special
"brain-dead ATA mode" that doesn't inhibit solutions that can
implement Discard w/o the "queue draining" required by the broken
implementation.

Chris
P.S. Why was ext2/discard functionality removed?
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
