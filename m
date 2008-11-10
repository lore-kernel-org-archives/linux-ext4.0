From: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH]: ext4: fix big endian
Date: Mon, 10 Nov 2008 10:09:38 -0800
Message-ID: <1226340578.22742.4.camel@brick>
References: <200811061600.54264.borntraeger@de.ibm.com>
	 <200811061651.49602.borntraeger@de.ibm.com> <49131601.50407@redhat.com>
	 <20081106163846.GA1381@infradead.org> <20081106173327.GF18939@mit.edu>
	 <20081106173944.GA23398@infradead.org>  <20081108223504.GA1301@logfs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Christoph Hellwig <hch@infradead.org>,
	Theodore Tso <tytso@mit.edu>,
	Peter Staubach <staubach@redhat.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:24165 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114AbYKJSJm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 10 Nov 2008 13:09:42 -0500
In-Reply-To: <20081108223504.GA1301@logfs.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, 2008-11-08 at 23:35 +0100, J=C3=B6rn Engel wrote:
> On Thu, 6 November 2008 12:39:44 -0500, Christoph Hellwig wrote:
> >=20
> > Heh, okay.  We really should try to find some annotations that run
> > sparse with endian checking by default for those parts of the tree
> > where it makes sense..
>=20
> #define __CHECK_ENDIAN__ in some ext4 header.  Made life much easier =
for
> me.
>=20

I'd say that it's getting close to just being able to turn it on by
default.  A lot of the really verbose offenders have been annotated
now, drivers/ieee1394, drivers/scsi, drivers/message and some of the
older areas of drivers/net will get noisy, I was going to send an RFC
for 2.6.29 and continue to chip away at the output.

Harvey

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
