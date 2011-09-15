From: Ted Ts'o <tytso@mit.edu>
Subject: Re: On-disk field assignments for metadata checksum and snapshots
Date: Thu, 15 Sep 2011 13:57:55 -0400
Message-ID: <20110915175755.GK15782@thunk.org>
References: <E1R4Dby-0005qO-I2@tytso-glaptop.cam.corp.google.com>
 <CAOQ4uxihCk=o2C8Htzn5JgnbZ3zRSS+JhaiCw=gcDdgLojd94Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, linux-ext4@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:44437 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934040Ab1IOR56 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 15 Sep 2011 13:57:58 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uxihCk=o2C8Htzn5JgnbZ3zRSS+JhaiCw=gcDdgLojd94Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 15, 2011 at 07:01:47PM +0300, Amir Goldstein wrote:
> > + =A0 =A0 =A0 { =A0 =A0 =A0 E2P_FEATURE_COMPAT, EXT2_FEATURE_COMPAT=
_EXCLUDE_BITMAP,
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "snapshot" },
>=20
> The feature name should read "exclude_bitmap".
> This is a COMPAT feature which should be set by default on every mkfs=
=2Eext4.
> The "has_snapshot" (or "snapshots") feature is a RO_COMPAT feature, w=
hich
> can be turned on and off, depending on whether you want to enable or
> disable snapshots.

Yeah, I was trying to use a name which would be a bit more descriptive
than "exclude_bitmap", but I agree that will get very confusing with
the "has_snapshot" feature name.

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
