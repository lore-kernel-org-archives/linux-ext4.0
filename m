From: =?ISO-8859-1?Q?=22Andr=E9s_G=2E_Aragoneses_=5B_knocte_=5D?=
	 =?ISO-8859-1?Q?=22?= <knocte@gmail.com>
Subject: Re: Discussion about a "dirty bit" in the filesystem
Date: Wed, 01 Nov 2006 20:24:28 +0100
Message-ID: <4548F46C.7030006@gmail.com>
References: <ehdt24$iau$1@sea.gmane.org> <20061022010950.GC9082@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:8583 "EHLO ciao.gmane.org")
	by vger.kernel.org with ESMTP id S2992731AbWKATYf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 1 Nov 2006 14:24:35 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1GfLgy-0004mf-BA
	for linux-ext4@vger.kernel.org; Wed, 01 Nov 2006 20:24:05 +0100
Received: from 106.red-83-46-75.dynamicip.rima-tde.net ([83.46.75.106])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 01 Nov 2006 20:24:04 +0100
Received: from knocte by 106.red-83-46-75.dynamicip.rima-tde.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-ext4@vger.kernel.org>; Wed, 01 Nov 2006 20:24:04 +0100
To: linux-ext4@vger.kernel.org
In-Reply-To: <20061022010950.GC9082@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Thanks for your comments Theodore.

Sorry for the delay answering this. See inline,

> I'm not at all sure what this has to do with ext4 at all.  The last
> message indicates a major problem with your request, which is that if
> a FAT partition is mounted by Linux, and in the middle of being
> modified when the system is undergoing hibernation, and then Windows
> is booted and modifies the filesystem, you can lose data.  But that's
> because the FAT filesystem can be understood by both Windows and
> Linux.  (Presumably this problem would also occur, in a much worse
> case, using NTFS.)  But this has nothing to do with ext4.

Well, forget for the moment that other filesystems exist and imagine th=
e
same situation with ext filesystems. Implementing the "dirty" bit we
could avoid mounting a filesystem that is in use by an hibernated parti=
tion.

The feature, as is, is not very useful if it's only implemented in
ext3/ext4, but it would be a nice proof of concept and probably makes
other filesystem vendors implement the same.

> I can imagine someone writing an improved hibernate script which
> checks to see if a filesystem which could be understood by Windows
> (i.e., FAT or NTFS) is mounted, and if any such filesystems are
> mounted, disable the ability to boot into Windows after the
> hibernation.  I could even imagine an improved hibernate script which
> detects this case, and attempts to unmount the FAT and NTFS
> filesystems, and if it could successfully unmount them all, allow the
> user to reboot into Windows after hibernation.

=46or an hibernation script to detect this, first we must implement the
feature to allow the script to detect it, so this is what I am asking f=
or.

Perhaps now I have been clearer?

Thanks,

	Andr=E9s	[ knocte ]

--=20
