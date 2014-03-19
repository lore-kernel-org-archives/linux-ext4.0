From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] mke2fs: don't interact with a non tty
Date: Wed, 19 Mar 2014 18:05:20 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403191758160.14658@localhost.localdomain>
References: <1395162718-22586-1-git-send-email-psusi@ubuntu.com> <A5AC507A-847C-496C-99FF-DE48BE224D80@dilger.ca> <532894D9.4030409@ubuntu.com> <alpine.LFD.2.00.1403191217001.2119@localhost.localdomain> <53299D1F.6020307@ubuntu.com>
 <alpine.LFD.2.00.1403191604150.5960@localhost.localdomain> <5329BFFA.1030308@ubuntu.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2096914964-1395248723=:14658"
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933574AbaCSRF2 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 19 Mar 2014 13:05:28 -0400
In-Reply-To: <5329BFFA.1030308@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2096914964-1395248723=:14658
Content-Type: TEXT/PLAIN; charset=windows-1252
Content-Transfer-Encoding: 8BIT

On Wed, 19 Mar 2014, Phillip Susi wrote:

> Date: Wed, 19 Mar 2014 12:04:10 -0400
> From: Phillip Susi <psusi@ubuntu.com>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] mke2fs: don't interact with a non tty
> 
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 3/19/2014 11:16 AM, Lukáš Czerner wrote:
> > There was a discussion between me and Dave Chinner a while ago
> > about exactly this topic and he made some very good points. You as
> > a guy working with file system, or file system utilities, testing
> > them and so on will probably see a ton of the warning like that.
> > But like it, or not you're *not* the typical user - you're a
> > developer and there is a huge difference.
> 
> Whether I'm a typical user or a developer does not matter.  This is
> unix, and commands are expected to do what they are told.  If you must
> do such silly things, at the very least you need to not break scripts
> when doing it, which means if stdin is not a tty, don't assume you are
> being run by an idiot who needs hand holding and do what you've been
> told to.
> 
> Scripts and other tools like say, gparted, should not have to figure
> out every silly thing you might complain about and add a stupid
> - --yes-i-really-meant-it flag to every invocation.

You're wrong. It does matter, because the usage habits of those two
groups are entirely different and certainly mke2fs is not a tool
designed for developers.

It is a safety net for already overwhelmed sysadmins. And I do not
understand how this is breaking scripts - it has been like that for
a long time.

I agree that it is a bug that we're still asking question even though
there is not a tty attached, but as I said the right thing to do in
that case is to fail rather than blindly continue despite the checks.
If you want the latter, you can use the 'force' Luke :)

Thanks!
-Lukas

> 
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v2.0.17 (MingW32)
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
> 
> iQEcBAEBAgAGBQJTKb/6AAoJEI5FoCIzSKrwefcIAIHJtyiquS/Zrs4LbCSW1Zoe
> 5QoLx1ROxqP/Y5CP9mMCcRfsOTXMtZWqf116/Hg5SgIbJ76FGn7peChfPAKw477W
> HFPWsUmWgdkdVRFJdqny/5MVaOHGd/bD9mt7/8suEwSXX3eAp/gDegKR9Srm+etY
> n7V/G/uHWQgUQDbs8GAAcpIMA4Y1zcARB19fdNMr1evhDORdN7PAFqxqbixz3gU6
> //ZnztB7mkDB+cDq9aEYIFR0NnUT8d1SlPR0K/S42Ygy/byP96PjFV+Fkcs7kUA3
> DlWUgJxC7hr5VnF/PxU11ydiU90NT6NmhRSz/0++tlgGQzNXnHuGMyTtvvHJj30=
> =BX1H
> -----END PGP SIGNATURE-----
> 
--8323328-2096914964-1395248723=:14658--
