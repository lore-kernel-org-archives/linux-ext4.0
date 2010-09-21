From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: uninit_bg compatibility?
Date: Tue, 21 Sep 2010 10:00:22 -0700
Message-ID: <40E7666A-17B8-4D39-A078-8FE3379C2AA5@dilger.ca>
References: <Pine.A41.4.64.1009211500110.1245260@stalin.acc.umu.se>
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: =?iso-8859-1?Q?Bo_Brant=E9n?= <bosse@acc.umu.se>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:39066 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757861Ab0IURAY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Sep 2010 13:00:24 -0400
In-Reply-To: <Pine.A41.4.64.1009211500110.1245260@stalin.acc.umu.se>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2010-09-21, at 06:28, Bo Brant=E9n wrote:
> when writing new files to an ext4 file system using the Windows drive=
r fsck will later complain "Group descriptor nn checksum is invalid" an=
d I think that is because it used an yet unused block group without kno=
wing that they can be marked as uninitialized. So I thought a simple pa=
tch would be to mount the file system read-only if that feature is in u=
se untill the driver is updated with full write support but I can't fin=
d the flag to use, there is no EXT4_FEATURE_RO_COMPAT_UNINIT_BG so I th=
ought I ask here if anyone could clear this out.

The Windows driver (or any driver for that matter) should ONLY allow re=
ad-only access if ANY feature in s_feature_ro_compat is unknown, and co=
mpletely refuse to mount if any feature in s_feature_incompat is unknow=
n.

The actual feature flag is called EXT4_FEATURE_RO_COMPAT_GDT_CSUM, but =
that doesn't matter, since what the code should be doing is masking off=
 the features that it DOES understand and checking if any feature bits =
are remaining.


Cheers, Andreas





--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
