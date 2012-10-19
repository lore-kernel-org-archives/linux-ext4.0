From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: EXT4-fs error w/ external USB drive
Date: Fri, 19 Oct 2012 17:07:23 -0400
Message-ID: <20121019210723.GA4721@thunk.org>
References: <507C4BDA.20205@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <507C4BDA.20205@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 15, 2012 at 07:46:02PM +0200, Toralf F=F6rster wrote:
> Even with current stable kernel 3.6.2 I sometimes get those syslog me=
ssages :
>=20
>=20
> 2012-10-15T19:37:58.401+02:00 n22 kernel: EXT4-fs error (device sdb3)=
: ext4_mb_generate_buddy:741: group 436, 22902 clusters in bitmap, 2290=
1 in gd

Have you run e2fsck to clean up the file system corruption?  If you
have, do you continually get these errors afterwards?

You say this is an external USB disk; is there any possibility of the
disk getting unmounted uncleanly due to the cable getting pulled out
while the disk is still mounted, and then the disk getting remounted
w/o having e2fsck run on the disk?

					- Ted
