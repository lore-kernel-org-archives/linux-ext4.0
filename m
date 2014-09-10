From: TR Reardon <thomas_reardon@hotmail.com>
Subject: tune2fs -O ^metadata_csum not checking bitmap failures
Date: Wed, 10 Sep 2014 16:30:41 -0400
Message-ID: <BAY179-W1203B52FCFC4FE2CA267BDFDCF0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "darrick.wong@oracle.com" <darrick.wong@oracle.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from bay004-omc4s24.hotmail.com ([65.54.190.226]:55522 "EHLO
	BAY004-OMC4S24.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753078AbaIJUam convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Sep 2014 16:30:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

When running tune2fs -O ^metadata_csum, disable_uninit_bg() is called t=
o reset the gdt. =A0However, return value is not checked, which allows =
a failure (say, a block bitmap failure somewhere, among other errors) t=
o continue through to rewrite_metadata_checksums()

This seems wrong; should not the rewrite occur only if disable/enable_u=
ninit_bg() succeeds?

+Reardon 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
