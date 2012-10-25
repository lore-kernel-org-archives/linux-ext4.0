From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: EXT4-fs error w/ external USB drive
Date: Thu, 25 Oct 2012 14:20:04 -0400
Message-ID: <20121025182004.GA16257@thunk.org>
References: <507C4BDA.20205@gmx.de>
 <20121019210723.GA4721@thunk.org>
 <5085923F.9050801@gmx.de>
 <20121024011128.GG28626@thunk.org>
 <5088260D.7080403@gmx.de>
 <20121024183505.GA6142@thunk.org>
 <50896B42.90606@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Eric Sandeen <sandeen@redhat.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57566 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759774Ab2JYSUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 25 Oct 2012 14:20:09 -0400
Content-Disposition: inline
In-Reply-To: <50896B42.90606@gmx.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Oct 25, 2012 at 06:39:30PM +0200, Toralf F=F6rster wrote:
> After a lot of file operations (Gentoo emerging, kernel build, git
> pulls, ...) I s2disk the system (that with the external USB drive)
> yesterday, wake it up today, rebooted it -
> and had to manually repair the file system, because the automatic fsc=
k
> gave up.

OK, I'm going to send another patch series which I'd hope you could
test to see if reduces the rate at which this happens.

> Nevertheless there's another Linux system I have (64bit RH EL,interna=
l
> drive), where with kernel 3.5.4-1.el6.elrepo.x86_64 EXT4 errors occur=
red.
> I attached the whole appropriate section of /var/log/message.

I don't have easy access to the RHEL kernel sources, and so I don't
know which patches were applied.  Specifically, I'd really like to
know if the commit represented by 14b4ed22a6 is in RHEL
3.5.4-1.el6.elrepo.  Also, I'd like to know which line number was
reflected here, which was the first EXT4-fs error:

> Sep 26 09:26:54 x kernel: EXT4-fs error (device dm-1) in ext4_new_ino=
de:938: IO failure

This was from fs/ext4/ialloc.c line 938, and there are two
ext4_std_error() that this could represent, so which is why having the
exact kernel sources from this RHEL kernel would be useful.  (I'd also
suggest opening a RHEL support ticket if you have a support contract,
since that way Red Hat can track this issue, and that way Eric can
count the work he's been doing on this fire drill as supporting a
customer.  :-)

What's a bit unfortunate is that there was no other error messages
before this line.  So we can't know for sure what caused or returned
the -EIO error code.  I *suspect* it was this, which would would be
indocate a corrupted inode bitmap:

	if (insert_inode_locked(inode) < 0) {
		/*
		 * Likely a bitmap corruption causing inode to be allocated
		 * twice.
		 */
		err =3D -EIO;
		goto fail;
	}

Do you know if this external disk could have suffered from a cable
pull, or a flaky cable, or some kind of unclean shutdown/power failure
before it rebooted?  That would be an interesting data point. =20

=46or the future, we need to add some better error reporting for
failures such as this.  In addition, I have a recent change we made at
work that I should get upstream which avoids allocating from a block
group once we notice a corruption (currently just for the block
allocations, but I think we should do this for inode allocations as
well), to minimize the chances of lost data once we notice that the
block/inode allocation bitmap can't be trusted.  This avoids data loss
in the case where users are using the default errors=3Dcontinue instead
of errors=3Dpanic or errors=3Dremount-ro.

Speaking of which, for your production RHEL server, you might want to
seriously consider errors=3Dpanic for any critical file system volume.
This allows the file system to get corrected via e2fsck, and prevents
the server from stumbling along, possibly causing more data loss due
to a fs corruption.

Regards,

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
