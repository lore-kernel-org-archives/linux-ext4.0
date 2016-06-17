From: Lars Wijtemans <lars@wijtemans.nl>
Subject: Re: PROBLEM: [SOLVED] incorrect data block bitmap after running
 resize2fs and e2fsck
Date: Fri, 17 Jun 2016 19:58:50 +0200
Message-ID: <1466186330.5128.5.camel@wijtemans.nl>
References: <1466175303.22666.10.camel@wijtemans.nl>
	 <7B51A758-2F9E-4020-BF55-31D234E1EFD9@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from vs2.de.wijtemans.nl ([78.47.216.174]:50311 "EHLO
	vs2.de.wijtemans.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbcFQR6z (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 17 Jun 2016 13:58:55 -0400
In-Reply-To: <7B51A758-2F9E-4020-BF55-31D234E1EFD9@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Thank you so much! Running e2fsck 1.43.1 seems to have fixed this in
the right way. That was an oversight on my part.

Regards, Lars-----Original Message-----
=46rom: Andreas Dilger <adilger@dilger.ca>
Date: Fri, 17 Jun 2016 09:25:24 -0600

Ted has just released 1.43.1 that fixes a number of problems with
1.42.13.=C2=A0

You might also consider trying 1.42.13 if you haven't enabled any of
the new features in 1.43 (data checksums, inline data, etc.).=C2=A0

Cheers, Andreas

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
