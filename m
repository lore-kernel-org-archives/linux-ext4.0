From: Pascal Terjan <pterjan@mandriva.com>
Subject: Re: Possible ext3 corruption with 1K block size
Date: Thu, 16 Oct 2008 15:47:40 +0200
Message-ID: <1224164860.11578.14.camel@plop>
References: <200810150724.42180.arvidjaar@mail.ru>
	 <48F5E6D4.8080603@redhat.com> <200810151824.36119.arvidjaar@mail.ru>
	 <48F601A5.1050405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, pterjan@mandriva.org,
	linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753493AbYJPNsL@vger.kernel.org>
In-Reply-To: <48F601A5.1050405@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Le mercredi 15 octobre 2008 =E0 09:43 -0500, Eric Sandeen a =E9crit :
> Andrey Borzenkov wrote:
> > On Wednesday 15 October 2008, Eric Sandeen wrote:
>=20
>=20
> >> My kingdom for a testcase... does anyone have simple steps to repr=
oduce
> >> this?  Or do they all start with "install mandriva on a 1k block s=
ize
> >> system?"  :)
> >>
> >=20
> > May be RH will do? :)
>=20
> I did try a 1k-block root fs Fedora install, and didn't see any probl=
ems...
>=20
> > As indicated by last comment, Pascal has some ways to trigger it; I
> > forgot to Cc to him initially; doing it now.
>=20
> Ok, good deal.
>=20

On my test machine I reproduce it easily : rpm --rebuilddb and if the d=
b
is not detected to be corrupted yet it will be after installing a few
packages (tested again with 2.6.27).

If I do the rebuilddb on a 2.6.17 and then reboot on a recent kernel,
then I can install/uninstall thousands of packages without any
corruption.

I wanted to try a few things including copying the partition to a file
and trying to reproduce in a vm.

Given how I can reproduce and repair it i can even write a bisecting
script which would basically be an initscript which would do

if on test kernel
- rebuild the db
- install 10 rpm
- remove the 10 rpm
- check the db
- do the good/bad
- reboot onto 2.6.17
else if on 2.6.17
- rebuild the db
- build the kernel
- reboot on test kernel

and let it run :)

All I need is to find some time with nothing more urgent...
