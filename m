From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH] mke2fs: don't interact with a non tty
Date: Wed, 19 Mar 2014 09:35:27 -0400
Message-ID: <53299D1F.6020307@ubuntu.com>
References: <1395162718-22586-1-git-send-email-psusi@ubuntu.com> <A5AC507A-847C-496C-99FF-DE48BE224D80@dilger.ca> <532894D9.4030409@ubuntu.com> <alpine.LFD.2.00.1403191217001.2119@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:61193 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996AbaCSNf3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Mar 2014 09:35:29 -0400
In-Reply-To: <alpine.LFD.2.00.1403191217001.2119@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 3/19/2014 7:26 AM, Luk=E1=9A Czerner wrote:
> Yes, it is inconsistent especially in the way that mke2fs is=20
> proceeding without any problem on the device which already
> contains a valid file system (or any other) signature. Which I
> think we should really change. The problem is that this will break
> scripts for everybody which is bad.
>=20
> So my idea was to implement the signature check and then skip it
> if we do not have a tty attached. Just to avoid the breakage.
>=20
> However I do not think that we can just blindly ignore the checks
> we already have in place in the case that there is no user. But I
> agree that current behaviour is wrong and it should be changed,
> however I think that we need to change it the other way, the
> default should be no - do not proceed and exit. Because believe it
> or not, people make mistakes.

Then you are right back to breaking scripts.  And yes, people make
mistakes... and unix *lets* them.  You don't see rm stopping every
time you try to delete a file and saying really?  *That* file?  Are
you sure?  You don't see dd or shell redirection stopping to ask you
if you really meant to overwrite that disk or file.  There is a
*reason* why you are supposed to double check commands you are running
as root.

And putting a filesystem in an image file is one of the *least*
dangerous things you could do.  Of all of the things to second guess,
and especially to default to "HALT! ERROR!" behavior, this has to be
the silliest.

If you can't assume that an interactive user knows what they are doing
and meant what they said, then at least you should assume that a
script writer knows wtf they are doing without asking them to add lots
of silly --yes-i-know-what-im-doing-stop-annoying-me flags.

> Agreed, but it should not be lifted, but rather changes to check
> for signatures on the device. The same way as it is done for
> example in xfs, or btrfs.

*NO*!  Those tools annoy the hell out of me because they do that.  I
*know* there is another filesystem there already ( as there are on
most disks not fresh from the factory ), why do you think I'm telling
you to change it?  Do what I asked and stop treating me like a child.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTKZ0fAAoJEI5FoCIzSKrwaFQH/RO0NPl2mPAlpaK2YQysegub
u80nYpSlpHjiIOLU7RCECakfELIFp1skg7lRsFdL1zLNkor4JkwW8UbOuy75WbS3
+XPAQ/1wxPzsn0J4+QM3PE3X/IZ4NWRMepl0pozpoLine87mL6u6+em2n1r1vsQK
HE/1Ma/8jqPPMXPNFDw0LMiYGyAHITfQA4c/FRwlWCbhMt2lG8dsGA7bKl7VCB5D
gmkzUF/KbgmY8xnDiIbmSHQbaF+xrIbZl8FGgi4r3CuiGZ2yZBBbs2sTCk6pvIq7
rrTQGwxBuzxaas2h+ZpLfTeFulBlIH2B+ueStinc2Br+TmBeqIKKOQ1+HjO3v6g=3D
=3D6eGY
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
