From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/3] jbd2 : Fix journal start by passing a parameter to
 specify if the caller can deal with ENOMEM
Date: Thu, 26 May 2011 16:51:51 +0200
Message-ID: <20110526145151.GC5123@quack.suse.cz>
References: <4DDCAF18.8030809@gmail.com>
 <20110525074457.GA4427@quack.suse.cz>
 <4DDCB3FA.2070009@gmail.com>
 <20110525081333.GB4427@quack.suse.cz>
 <20110526022251.GG9520@thunk.org>
 <BANLkTi=QuZfvDohsawA75kWQuYuJvsHQiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Ted Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: Manish Katiyar <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39788 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701Ab1EZOvx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 26 May 2011 10:51:53 -0400
Content-Disposition: inline
In-Reply-To: <BANLkTi=QuZfvDohsawA75kWQuYuJvsHQiA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi Manish,

On Wed 25-05-11 22:29:59, Manish Katiyar wrote:
> On Wed, May 25, 2011 at 7:22 PM, Ted Ts'o <tytso@mit.edu> wrote:
> > On Wed, May 25, 2011 at 10:13:33AM +0200, Jan Kara wrote:
> >> >
> >> > =A0 =A0ok.. I will do it as a separate patch.
> >> =A0 Well, patch 2/3 does not really make too much sense without it=
 (errok
> >> parameter isn't used) so there's no reason to do it as a separate =
patch.
> >> Just add it to this patch please.
> >
> > Agreed; right now this whole patch series is a no-op, since errok
> > isn't getting used for anything. =A0So fixing errok so it's passed =
to
> > start_this_handle() seems to be more in the category of "fix the
> > patch" more than anything else.
> >
> > One more thing; perhaps we should be passing in a integer so we can
> > pass in a flag word. =A0That way you don't need to have a fail_ok
> > variant. =A0It's a lot more obvious if you have a call:
> >
> > =A0 =A0 =A0 =A0 =A0handle =3D ext4_journal_start(inode, 1, JBD2_FAI=
L_OK);
> >
> > What we can also do is this:
> >
> > =A0 =A0 =A0 =A0 =A0handle =3D ext4_journal_start(inode, 1, JBD2_FAI=
L_OK | JBD2_TOPLEVEL);
> >
> > What JBD2_TOPLEVEL means is that caller is from a top-level file
> > system function, such as ext4_symlink() or ext4_chmod(), such that
> > start_this_handle() can use GFP_KERNEL instead of GFP_NOFS. =A0GFP_=
NOFS
> > is needed for any function that might get called by the direct recl=
aim
> > path (i.e., the writepage() function). =A0But for the top-level
> > symlink() or chmod() function, it's actually OK to allocate memory
> > using GFP_KERNEL, since there's no potential recursion problem.
>=20
> Will it be more desirable to have the patch fixed as JBD2_FAIL_OK as
> you suggested above ? I have already
> fixed the patch to pass errok to start_this_handle() and then retry o=
r
> not based on that, and was planning to send
> it. But if this needs to be fixed this way, then I will rework it the=
n send.
  Well, I don't care much and Ted seems to like flags more. As he is th=
e
maintainer, I guess just follow his advice ;).

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
