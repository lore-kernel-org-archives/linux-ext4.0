From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: tune2fs -O ^metadata_csum not checking bitmap failures
Date: Wed, 10 Sep 2014 13:48:40 -0700
Message-ID: <20140910204840.GH10351@birch.djwong.org>
References: <BAY179-W1203B52FCFC4FE2CA267BDFDCF0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: TR Reardon <thomas_reardon@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36817 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbaIJUsq (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 10 Sep 2014 16:48:46 -0400
Content-Disposition: inline
In-Reply-To: <BAY179-W1203B52FCFC4FE2CA267BDFDCF0@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Sep 10, 2014 at 04:30:41PM -0400, TR Reardon wrote:
> When running tune2fs -O ^metadata_csum, disable_uninit_bg() is called=
 to
> reset the gdt. =A0However, return value is not checked, which allows =
a failure
> (say, a block bitmap failure somewhere, among other errors) to contin=
ue
> through to rewrite_metadata_checksums()
>=20
> This seems wrong; should not the rewrite occur only if
> disable/enable_uninit_bg() succeeds?

The rewrite will fail if either of the error cases in disable_uninit_bg=
() fail,
since rewrite_metadata_checksums() also tries to load the bitmap and sc=
an the
inodes.

However, I wouldn't want to guarantee that in perpetuity, so let's chec=
k the
error codes anyway.

--D

>=20
> +Reardon 		 	   		  --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
