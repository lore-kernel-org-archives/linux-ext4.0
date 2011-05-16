From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/5] jbd2: Pass extra bool parameter in journal
 routines to specify if its ok to fail the journal transaction allocation.
Date: Mon, 16 May 2011 17:51:38 +0200
Message-ID: <20110516155138.GI5344@quack.suse.cz>
References: <BANLkTinNUxt_Bj0JErLVDbh=73JHzzS9=w@mail.gmail.com>
 <20110511155447.GH5057@quack.suse.cz>
 <BANLkTikP3axXkZ=v8EbpbzyoeSeARZC_Ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, ext4 <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:57820 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756535Ab1EPPwB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 16 May 2011 11:52:01 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTikP3axXkZ=v8EbpbzyoeSeARZC_Ew@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Thu 12-05-11 23:37:05, Manish Katiyar wrote:
> On Wed, May 11, 2011 at 8:54 AM, Jan Kara <jack@suse.cz> wrote:
> > =A0Hi,
> >
> > =A0sorry I got to your patches with a delay. One general note - ple=
ase do
> > not attach patches. It is enough to have them in the email...
> >
> > On Sun 24-04-11 17:10:41, Manish Katiyar wrote:
> >> Pass extra bool parameter in journal routines to specify if its ok=
 to
> >> fail the journal transaction allocation. If 'true' is passed
> >> transaction allocation is done through GFP_KERNEL =A0and ENOMEM is
> >> returned else GFP_NOFS is used.
> > =A0Please, do not mix error handling with gfp masks. Instead just r=
ename
> > jbd2__journal_start() to jbd2_journal_start() and change gfp_mask p=
arameter
> > to "bool errok".
>=20
> ok.
>=20
> > Use GFP_NOFS gfp mask for start_this_handle().
> I think I didn't completely understand this line. You meant passing
> GFP_KERNEL or GFP_NOFS based on errok right ?
  No, I meant passing GFP_NOFS always. Currently, GFP_NOFS is used in a=
ll
the cases (noone uses GFP_KERNEL variant) and GFP_KERNEL can really be =
used
only when we do not hold other filesystem locks (as GFP_KERNEL allocati=
on
can recurse back into filesystem to reclaim memory). So using GFP_KERNE=
L
would need more auditting and is a separate issue anyway.

> > Also your patch series should be bisectable - that means it must co=
mpile
> > and run after any of the patches. So you cannot really change
> > jbd2_journal_start() prototype without changing all the filesystems=
 using
> > it. In this case, just include in this patch a simple change for ex=
t4 and
> > ocfs2 to pass 'false' in the additional argument.
>=20
> ok.. Will submit the first patch as everyone passing false as the
> errok argument.
  Thanks.

									Honza

--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
