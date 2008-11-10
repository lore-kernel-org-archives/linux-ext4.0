From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH]: ext4: fix big endian
Date: Mon, 10 Nov 2008 20:31:36 +0100
Message-ID: <20081110193135.GA18378@logfs.org>
References: <200811061600.54264.borntraeger@de.ibm.com> <200811061651.49602.borntraeger@de.ibm.com> <49131601.50407@redhat.com> <20081106163846.GA1381@infradead.org> <20081106173327.GF18939@mit.edu> <20081106173944.GA23398@infradead.org> <20081108223504.GA1301@logfs.org> <1226340578.22742.4.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch@infradead.org>,
	Theodore Tso <tytso@mit.edu>,
	Peter Staubach <staubach@redhat.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Harvey Harrison <harvey.harrison@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lazybastard.de ([212.112.238.170]:37238 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbYKJTcL (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Nov 2008 14:32:11 -0500
Content-Disposition: inline
In-Reply-To: <1226340578.22742.4.camel@brick>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, 10 November 2008 10:09:38 -0800, Harvey Harrison wrote:
>=20
> I'd say that it's getting close to just being able to turn it on by
> default.  A lot of the really verbose offenders have been annotated
> now, drivers/ieee1394, drivers/scsi, drivers/message and some of the
> older areas of drivers/net will get noisy, I was going to send an RFC
> for 2.6.29 and continue to chip away at the output.

My argument for the define is that it doesn't hurt much if endian check=
s
are enabled globally, but helps a lot if they are not.  So until it is
clear that endian checks will be enabled, it may still be a good idea.

J=C3=B6rn

--=20
It's not whether you win or lose, it's how you place the blame.
-- unknown
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
