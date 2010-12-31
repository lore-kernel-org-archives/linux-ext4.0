From: Joel Becker <Joel.Becker@oracle.com>
Subject: Re: Confused by commit 56a76f [fs: fix page_mkwrite error cases in
 core code and btrfs]
Date: Fri, 31 Dec 2010 03:39:50 -0800
Message-ID: <20101231113949.GA21179@mail.oracle.com>
References: <20101230232936.GA931@mail.oracle.com>
 <AANLkTi=afH_Qqb0wfn4UjXju__QjKKa+cBTS4tO5o2NJ@mail.gmail.com>
 <20101231110054.GA20521@mail.oracle.com>
 <AANLkTik3_=Jo2ubML1hhanFFKC3MkEibrCPruto2oY_v@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
To: Nick Piggin <npiggin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:38272 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab0LaLly (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Dec 2010 06:41:54 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTik3_=Jo2ubML1hhanFFKC3MkEibrCPruto2oY_v@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 31, 2010 at 10:16:35PM +1100, Nick Piggin wrote:
> On Fri, Dec 31, 2010 at 10:00 PM, Joel Becker <jlbec@evilplan.org> wr=
ote:
> > On Fri, Dec 31, 2010 at 08:31:41PM +1100, Nick Piggin wrote:
> >> On Fri, Dec 31, 2010 at 10:29 AM, Joel Becker <Joel.Becker@oracle.=
com> wrote:
>=20
> >> The better way to do this would be to just return VM_FAULT_NOPAGE
> >> in any case you need the VM to retry the fault. When you reach the
> >> business end of your handler, you want to hold the page locked, af=
ter
> >> you verify it is correct, and return that to the fault handler.
> >
> > =A0 =A0 =A0 =A0This is going to be hard. =A0Our write_end() assumes=
 it must
> > unlock the pages (which is normal behavior for write(2)), but in th=
e
> > page_mkwrite() case we need to avoid the unlock to follow your
> > recommendation (we use our write_begin/write_end pair to trigger an=
y
> > allocation or zeroing needed before the page is writable).
>=20
> Yes that would be the best option. It is possible to use the unlocked
> return, but that still gives possibility of races in some cases. Cons=
ider

	Yes, I am aware of that.
=20
> Basically it would be nice for all filesystems to move to this conven=
tion
> so we can remove the old cruft.

	I can appreciate that.  And you've just answered the "Do you
want us to get there, or are minor faults in the old-0-style OK?"
question.
=20
> > =A0 =A0 =A0 =A0The find_or_create_page() is deep at the meat of the=
 function,
> > not the cursory check at the top. =A0The idea is that at this point=
,
> > find_or_create_page() will return a locked page that must, by
> > definition, be part of the correct mapping.
>=20
> But you must still handle failures there, because find_or_create_page
> may return -ENOMEM. So just lock the page, recheck the mapping
> there, and then do exactly the same error handling.

	Of course it can error, but error is different than clean
restart.  Though cleanup should be the same; I'm looking at our code
trying to convince myself that this is so ;-)  Btw, -ENOMEM is that OOM
fault error, right? ;-)

> > =A0 =A0 =A0 =A0If the VM is rechecking the pte after we return from
> > page_mkwrite(), won't it see any new page created?
>=20
> But the point of page_mkwrite is a dirty notifier for the fs. If this=
 new
> different page was installed due to say truncate then a read-only
> fault, the filesystem would miss the notification. So it just does th=
e
> simple thing and retries the whole sequence (if needed).

	Fair enough, even if we caused the new page and thus are already
notified ;-)
	Essentially, you would really like us (and ext4, and gfs2, etc)
to start returning VM_FAULT_NOPAGE for any place we aren't sure what
happened to our page, VM_FAULT_OOM when we get an -ENOMEM, and
VM_FAULT_LOCKED for all successful operations.  That the long and short
of it?  Thank you for helping me understand your plan for this code.
	Btw, what not use VM_FAULT_RETRY for "I'd like you to retry"?
Especially since the comment for NOPAGE doesn't read anything like its
actual behavior.

Joel

--=20

"Friends may come and go, but enemies accumulate."=20
        - Thomas Jones

Joel Becker
Senior Development Manager
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
