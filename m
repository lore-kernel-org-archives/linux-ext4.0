From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH e2fsprogs] - detect LVM2 PVs in libblkid
Date: Tue, 19 Feb 2008 06:27:31 -0500
Message-ID: <20080219112731.GV25098@mit.edu>
References: <47A1074F.8090909@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:36868 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752823AbYBSL1n (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 19 Feb 2008 06:27:43 -0500
Content-Disposition: inline
In-Reply-To: <47A1074F.8090909@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 30, 2008 at 05:25:03PM -0600, Eric Sandeen wrote:
> The anaconda folks are now using blkid instead of hand-rolled
> tests for filesystem type at install time, but they had one
> more request:
> 
> Bugzilla Bug 409321: RFE: information on blkdevs "formatted" as PVs
> https://bugzilla.redhat.com/show_bug.cgi?id=409321
> 
> The attached patch does the right thing for me on my sample
> set of exactly 1 PV...
> 
> Any issues with reporting back something which is not actually
> a filesystem ("lvm2pv") ?
> 
> [root@host]# misc/blkid -c /dev/null /dev/sda2
> /dev/sda2: UUID="guOQGdcOE3IafCm0190XkPZTy5fCEanQ" TYPE="lvm2pv" 
> [root@host]# pvs -o pv_name,pv_uuid
>   PV         PV UUID                               
>   /dev/sda2  guOQGd-cOE3-IafC-m019-0XkP-ZTy5-fCEanQ

The patch works for me, but it would seem the right thing would be
print the UUID without the hyphens, i.e.:

        guOQGdcOE3IafCm0190XkPZTy5fCEanQ

instead of

	guOQGd-cOE3-IafC-m019-0XkP-ZTy5-fCEanQ

After all, pvscan prints it with the hyphens, and blkid returns uuid's
with the hyphens for other filesystems as well.  And removing the
hyphens aren't hard; "tr -d -" will do it.

It's not that hard to convert from one to the other; this will do it:

	for (i=0, b=1, p=uuid, q=label->pv_uuid; i <= 32; i++, b = b << 1) {
		if (b & 0x4444440)
			*p++ = '-';
		*p++ = *q++;
	}

This shouldn't screw up the anaconda folks, since they just need to
know the filesystem type, right?  That's all vol_id seems to return in
any case.

						- Ted
