From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Subject: Re: [PATCH 0/5] fallocate system call
Date: Fri, 27 Apr 2007 16:43:28 +0200
Message-ID: <20070427144327.GC22949@lazybastard.org>
References: <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071417.GI355@devserv.devel.redhat.com> <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070427121003.GA7808@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, torvalds@osdl.org,
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lazybastard.de ([212.112.238.170]:32769 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755889AbXD0Ork (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 27 Apr 2007 10:47:40 -0400
Content-Disposition: inline
In-Reply-To: <20070427121003.GA7808@osiris.boeblingen.de.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 27 April 2007 14:10:03 +0200, Heiko Carstens wrote:
>=20
> After long discussions where at least two possible implementations
> were suggested that would work on _all_ architectures you chose one
> which doesn't and causes extra effort.

I believe the long discussion also showed that every possible
implementation has drawbacks.  To me this one appeared to be the best o=
f
many bad choices.

Is this implementation worse than we thought?

J=C3=B6rn

--=20
The grand essentials of happiness are: something to do, something to
love, and something to hope for.
-- Allan K. Chalmers
