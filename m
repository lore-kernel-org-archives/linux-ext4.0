From: Phillip Susi <psusi@ubuntu.com>
Subject: Re: [PATCH] mke2fs: don't interact with a non tty
Date: Wed, 19 Mar 2014 12:04:10 -0400
Message-ID: <5329BFFA.1030308@ubuntu.com>
References: <1395162718-22586-1-git-send-email-psusi@ubuntu.com> <A5AC507A-847C-496C-99FF-DE48BE224D80@dilger.ca> <532894D9.4030409@ubuntu.com> <alpine.LFD.2.00.1403191217001.2119@localhost.localdomain> <53299D1F.6020307@ubuntu.com> <alpine.LFD.2.00.1403191604150.5960@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: =?windows-1252?Q?Luk=E1=9A_Czerner?= <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:60376 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933574AbaCSQEM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 19 Mar 2014 12:04:12 -0400
In-Reply-To: <alpine.LFD.2.00.1403191604150.5960@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 3/19/2014 11:16 AM, Luk=E1=9A Czerner wrote:
> There was a discussion between me and Dave Chinner a while ago
> about exactly this topic and he made some very good points. You as
> a guy working with file system, or file system utilities, testing
> them and so on will probably see a ton of the warning like that.
> But like it, or not you're *not* the typical user - you're a
> developer and there is a huge difference.

Whether I'm a typical user or a developer does not matter.  This is
unix, and commands are expected to do what they are told.  If you must
do such silly things, at the very least you need to not break scripts
when doing it, which means if stdin is not a tty, don't assume you are
being run by an idiot who needs hand holding and do what you've been
told to.

Scripts and other tools like say, gparted, should not have to figure
out every silly thing you might complain about and add a stupid
- --yes-i-really-meant-it flag to every invocation.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTKb/6AAoJEI5FoCIzSKrwefcIAIHJtyiquS/Zrs4LbCSW1Zoe
5QoLx1ROxqP/Y5CP9mMCcRfsOTXMtZWqf116/Hg5SgIbJ76FGn7peChfPAKw477W
HFPWsUmWgdkdVRFJdqny/5MVaOHGd/bD9mt7/8suEwSXX3eAp/gDegKR9Srm+etY
n7V/G/uHWQgUQDbs8GAAcpIMA4Y1zcARB19fdNMr1evhDORdN7PAFqxqbixz3gU6
//ZnztB7mkDB+cDq9aEYIFR0NnUT8d1SlPR0K/S42Ygy/byP96PjFV+Fkcs7kUA3
DlWUgJxC7hr5VnF/PxU11ydiU90NT6NmhRSz/0++tlgGQzNXnHuGMyTtvvHJj30=3D
=3DBX1H
-----END PGP SIGNATURE-----
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
