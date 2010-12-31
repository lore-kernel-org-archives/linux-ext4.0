From: Joel Becker <jlbec@evilplan.org>
Subject: Re: Confused by commit 56a76f [fs: fix page_mkwrite error cases in
 core code and btrfs]
Date: Fri, 31 Dec 2010 03:00:55 -0800
Message-ID: <20101231110054.GA20521@mail.oracle.com>
References: <20101230232936.GA931@mail.oracle.com>
 <AANLkTi=afH_Qqb0wfn4UjXju__QjKKa+cBTS4tO5o2NJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	ocfs2-devel@oss.oracle.com
To: Nick Piggin <npiggin@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:39414 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab0LaLA7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 31 Dec 2010 06:00:59 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=afH_Qqb0wfn4UjXju__QjKKa+cBTS4tO5o2NJ@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Dec 31, 2010 at 08:31:41PM +1100, Nick Piggin wrote:
> On Fri, Dec 31, 2010 at 10:29 AM, Joel Becker <Joel.Becker@oracle.com=
> wrote:
> > Nick,
> > =A0 =A0 =A0 =A0While visiting some issues in ocfs2_page_mkwrite(), =
I realized
> > that we're returning 0 to mean "Please try again Mr VM", but the ca=
ller
>=20
> 0 has always meant minor fault, which means the filesystem satisfied
> the request without doing IO. In the change to bit mask return values=
,
> I kept it compatible by having major fault be presence of a bit, and =
minor
> fault indicate absence.

	Ok, good, the 0 is intentionally somewhat-working.

> NOPAGE basically means no further action on part of the VM is require=
d.
> It was used to consolidate pfn based fault handler with page based fa=
ult
> handler. And then, later, it was further used in this case to allow t=
he
> filesystem to have the VM try again in rare / difficult to handle err=
or cases
> exactly like truncate races.

	Ok, so it's not "no further action" anymore, it is "I don't have
a page, check again to see if I'm supposed to give you one."
That's how I read the code.  Cool.

> No it was all back compatible. That is to say, the ones that return S=
IGBUS
> in these cases were already broken, but the patch didn't break them f=
urther.
> Actaully it closed up races a bit, if I recall. But yes they should h=
ave all
> been converted to the new calling convention and returning with page
> locked.
>=20
> If the filesystem returns 0, it means minor fault, and the VM will ac=
tually
> install the page (unless the hack to check page->mapping catches it).

	Right, but does it install the page passed into page_mkwrite()?
The way I read the code, it actually rechecks the pte and installs the
page it now finds.

> > =A0 =A0 =A0 =A0Back to the ocfs2 issue. =A0Am I correctly reading t=
he current
> > code that we can safely throw away the page passed in to page_mkwri=
te()
> > if a pagecache flush has dropped it?
>=20
> Well you just return NOPAGE and the VM throws the page away.

	I mean, as we discuss below, that I ignore the page passed
to page_mkwrite() and rediscover the mapping ourselves.

> > =A0Currently, we presume that the
> > page passed in must be the one we make writable. =A0We make a quick=
 check
> > of page->mapping =3D=3D inode->i_mapping, returning 0 (for "try aga=
in")
> > immediately if that's false. =A0But once we get into the meat of ou=
r
> > locking and finally lock the page for good, we assume mapping=3D=3D=
i_mapping
> > still holds. =A0That obviously breaks when the pagecache gets trunc=
ated.
> > At this late stage, we -EINVAL (clearly wrong).
>=20
> The better way to do this would be to just return VM_FAULT_NOPAGE
> in any case you need the VM to retry the fault. When you reach the
> business end of your handler, you want to hold the page locked, after
> you verify it is correct, and return that to the fault handler.

	This is going to be hard.  Our write_end() assumes it must
unlock the pages (which is normal behavior for write(2)), but in the
page_mkwrite() case we need to avoid the unlock to follow your
recommendation (we use our write_begin/write_end pair to trigger any
allocation or zeroing needed before the page is writable).

> > =A0 =A0 =A0 =A0It looks hard to lock the page for good high up at o=
ur first
> > check of the mapping. =A0Wengang has proposed to simply ignore the =
page
> > passed into page_mkwrite() and just find_or_create_page() the sucke=
r at
> > the place we're ready to consider it stable. =A0As I see it, the tw=
o
> > places that call page_mkwrite() are going to revalidate the pte any=
way,
> > and they'll find the newly created page if find_or_create_page() ge=
ts a
> > different. =A0Is that safe behavior?
>=20
> I can't see the point. If you can find_or_create_page, then you can
> lock_page, by definition. Then check the mapping and
> VM_FAULT_SIGBUS if it is wrong.

	The find_or_create_page() is deep at the meat of the function,
not the cursory check at the top.  The idea is that at this point,
find_or_create_page() will return a locked page that must, by
definition, be part of the correct mapping.

> Messing with the wrong page will only see the result ignored by the V=
M,
> and push an incorrect page through parts of your fault handler, which
> is potentially confusing at best, I would have thought.

	If the VM is rechecking the pte after we return from
page_mkwrite(), won't it see any new page created?

Joel

--=20

"Egotist: a person more interested in himself than in me."
         - Ambrose Bierce=20

			http://www.jlbec.org/
			jlbec@evilplan.org
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
