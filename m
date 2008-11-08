From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH]: ext4: fix big endian
Date: Sat, 8 Nov 2008 23:35:07 +0100
Message-ID: <20081108223504.GA1301@logfs.org>
References: <200811061600.54264.borntraeger@de.ibm.com> <200811061651.49602.borntraeger@de.ibm.com> <49131601.50407@redhat.com> <20081106163846.GA1381@infradead.org> <20081106173327.GF18939@mit.edu> <20081106173944.GA23398@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Theodore Tso <tytso@mit.edu>, Peter Staubach <staubach@redhat.com>,
	Christian Borntraeger <borntraeger@de.ibm.com>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lazybastard.de ([212.112.238.170]:46147 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbYKHWgJ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 8 Nov 2008 17:36:09 -0500
Content-Disposition: inline
In-Reply-To: <20081106173944.GA23398@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 6 November 2008 12:39:44 -0500, Christoph Hellwig wrote:
>=20
> Heh, okay.  We really should try to find some annotations that run
> sparse with endian checking by default for those parts of the tree
> where it makes sense..

#define __CHECK_ENDIAN__ in some ext4 header.  Made life much easier fo=
r
me.

J=C3=B6rn

--=20
A surrounded army must be given a way out.
-- Sun Tzu
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
