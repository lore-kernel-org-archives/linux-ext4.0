From: Ted Ts'o <tytso@mit.edu>
Subject: Re: uninit_bg compatibility?
Date: Tue, 21 Sep 2010 13:59:12 -0400
Message-ID: <20100921175912.GA9597@thunk.org>
References: <Pine.A41.4.64.1009211500110.1245260@stalin.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Bo =?iso-8859-1?Q?Brant=E9n?= <bosse@acc.umu.se>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:55970 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754278Ab0IUR7P (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Sep 2010 13:59:15 -0400
Content-Disposition: inline
In-Reply-To: <Pine.A41.4.64.1009211500110.1245260@stalin.acc.umu.se>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 21, 2010 at 03:28:51PM +0200, Bo Brant=E9n wrote:
>=20
> when writing new files to an ext4 file system using the Windows
> driver fsck will later complain "Group descriptor nn checksum is
> invalid" and I think that is because it used an yet unused block
> group without knowing that they can be marked as uninitialized. So I
> thought a simple patch would be to mount the file system read-only
> if that feature is in use untill the driver is updated with full
> write support but I can't find the flag to use, there is no
> EXT4_FEATURE_RO_COMPAT_UNINIT_BG so I thought I ask here if anyone
> could clear this out.

Yeah, this is one where we decided to change the feature to uninit_bg
(since that describes the net benefit to the end-user), but we never
ended up changing the name of the flag in the source code.  The
feature flag in question is:

#define EXT4_FEATURE_RO_COMPAT_GDT_CSUM		0x0010

I'll note that the Windows driver must not be checking the feature
flags, since the whole point of RO_COMPAT flags is that if a file
system implementation (such as the Windows drivers) sees an RO_COMPAT
flag it doesn't understand, it's supposed to treat the file system as
read-only.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
