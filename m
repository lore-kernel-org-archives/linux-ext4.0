From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH v3]Ext4: journal credits reservation fixes for DIO,
	fallocate and delalloc writepages
Date: Mon, 4 Aug 2008 09:20:15 -0400
Message-ID: <20080804132015.GB8592@mit.edu>
References: <20080723074226.GA15091@skywalker> <1217032947.6394.2.camel@mingming-laptop> <1217383118.27664.14.camel@mingming-laptop> <1217417361.3373.15.camel@localhost> <1217527631.6317.6.camel@mingming-laptop> <20080801054932.GF8736@mit.edu> <1217613795.12413.15.camel@mingming-laptop> <20080801191015.GH8654@mit.edu> <20080802000305.GA8433@mit.edu> <1217849033.3275.3.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Mingming Cao <cmm@us.ibm.com>,
	Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	linux-ext4@vger.kernel.org,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>
To: =?iso-8859-1?Q?Fr=E9d=E9ric_Boh=E9?= <frederic.bohe@bull.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:35253 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756403AbYHDNVD (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 4 Aug 2008 09:21:03 -0400
Content-Disposition: inline
In-Reply-To: <1217849033.3275.3.camel@localhost>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 04, 2008 at 01:23:53PM +0200, Fr=E9d=E9ric Boh=E9 wrote:
>=20
> FYI, I have just tried this fix, and i don't see the "orphan list che=
ck
> failed" messages any more.
>=20

Thanks for checking!  I was able to reproduce the problem myself, and
confirm that it made it go away, so the patch is already in the patch
queue, and in fact has already been pushed to Linus.

       	      	       	       	    	      - Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
