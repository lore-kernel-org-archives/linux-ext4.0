From: Theodore Tso <tytso@mit.edu>
Subject: Re: Discussion about a "dirty bit" in the filesystem
Date: Sat, 21 Oct 2006 21:09:50 -0400
Message-ID: <20061022010950.GC9082@thunk.org>
References: <ehdt24$iau$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:5333 "EHLO thunker.thunk.org")
	by vger.kernel.org with ESMTP id S1161524AbWJVBJx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Sat, 21 Oct 2006 21:09:53 -0400
To: =?iso-8859-1?Q?Andr=E9s_G=2E_Aragoneses_=5B_knocte_=5D?=
	<knocte@gmail.com>
Content-Disposition: inline
In-Reply-To: <ehdt24$iau$1@sea.gmane.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, Oct 21, 2006 at 09:39:02PM +0200, "Andr=E9s G. Aragoneses [ kno=
cte ]" wrote:
> Hello. Sorry if this is not the correct place to talk about this.
>=20
> I am writing to this list because I am a user of openSUSE that opened
> filed a bug [1] against the issue tracking software of this linux
> distribution about boot management and hibernation. There was a
> discussion and then the bug was resolved to WONTFIX, but I think we
> could extract from it a nice FEATURE that any filesystem would have, =
or,
> in particular, ext4.
>=20
> [1] https://bugzilla.novell.com/show_bug.cgi?id=3D175939
>=20
> Any opinions?

I'm not at all sure what this has to do with ext4 at all.  The last
message indicates a major problem with your request, which is that if
a FAT partition is mounted by Linux, and in the middle of being
modified when the system is undergoing hibernation, and then Windows
is booted and modifies the filesystem, you can lose data.  But that's
because the FAT filesystem can be understood by both Windows and
Linux.  (Presumably this problem would also occur, in a much worse
case, using NTFS.)  But this has nothing to do with ext4.

I can imagine someone writing an improved hibernate script which
checks to see if a filesystem which could be understood by Windows
(i.e., FAT or NTFS) is mounted, and if any such filesystems are
mounted, disable the ability to boot into Windows after the
hibernation.  I could even imagine an improved hibernate script which
detects this case, and attempts to unmount the FAT and NTFS
filesystems, and if it could successfully unmount them all, allow the
user to reboot into Windows after hibernation.

However, this is not a ext4 filesystem matter, and not a kernel
matter, but rather a hibernation script issue.

Regards,

						- Ted
