From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH] mke2fs: don't interact with a non tty
Date: Wed, 19 Mar 2014 13:37:42 -0400
Message-ID: <5329D5E6.3090009@ubuntu.com>
References: <1395162718-22586-1-git-send-email-psusi@ubuntu.com> <A5AC507A-847C-496C-99FF-DE48BE224D80@dilger.ca> <532894D9.4030409@ubuntu.com> <alpine.LFD.2.00.1403191217001.2119@localhost.localdomain> <53299D1F.6020307@ubuntu.com> <alpine.LFD.2.00.1403191604150.5960@localhost.localdomain> <5329BFFA.1030308@ubuntu.com> <alpine.LFD.2.00.1403191758160.14658@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:46193 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaCSRho (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Mar 2014 13:37:44 -0400
In-Reply-To: <alpine.LFD.2.00.1403191758160.14658@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 3/19/2014 1:05 PM, Luk=E1=9A Czerner wrote:
> You're wrong. It does matter, because the usage habits of those
> two groups are entirely different and certainly mke2fs is not a
> tool designed for developers.

It is designed for system administrators who are used to tools doing
what they ask, and not second guessing them, even if that means doing
something harmful.  Unix lets you shoot yourself in the foot.  There
are hundreds of other similar "mistakes" an admin could make that
would cause similar harm, and none of them stop and say are you really
sure?  Neither should mkfs.

> It is a safety net for already overwhelmed sysadmins. And I do not=20
> understand how this is breaking scripts - it has been like that
> for a long time.

It breaks scripts because the tool fails when it shouldn't, and the
script now has to work around it with silly, fragile logic like "I'm
being asked to make an ext[234] filesystem on a regular file, so I
need to add this silly --i-meant-it flag." and "I'm, being asked to
make a btrfs filesystem on this disk, so I better add this other silly
flag to make sure it doesn't fail because there's already another fs
there" and "filesystem x needs this third silly flag" and so on.

> I agree that it is a bug that we're still asking question even
> though there is not a tty attached, but as I said the right thing
> to do in that case is to fail rather than blindly continue despite
> the checks. If you want the latter, you can use the 'force' Luke
> :)

Scripts should not have to keep adding different
- --yes-stupid-i-really-meant-it flags for special cased different
filesystems to get what they already said they wanted.  This is not
the unix way.  If you want hand holding, do it the way rm did: add a
flag that turns the hand holding on, and set up an alias so you don't
forget it when running it interactively.  Or better yet, use an
interactive gui tool that is designed to hold your hand and not be
scripted.

At the very least, don't assume the script is wrong because you can't
ask "are you sure, dummy?".

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTKdXmAAoJEI5FoCIzSKrw0R4H/R47g6bDEf749OH/BiRiNgLr
k5n+4e0ep68DRkAAWLuXdAjr29LCZiFLAWd2XV69aQ/Ls3Nj+R8fKZ6v3IharRHg
xDOFgrmv5QF7m3FgQVPS6qQEgCtGIprJdurQbcjwhQ26MwEF37hLRzJk4GRBLy7E
zydUpZrVvzzsWPX4/k8bI3ESFZoMiuX9zEEd9Fl3hjHMByeZ+zqnLSJgSBt+y3eU
fSpFY/F4pdzWKhEe0SOat1lGy6qFu92DVbRdJYTAGuDHiKqT7SHkpvt503+GHEAJ
uo+jN4JU1FFSn5+3+fCsJb3XSmrIbbsXaIWBi8/VsujhCaHXnxG48gblNf9KCWg=3D
=3DWhUQ
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
