From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
Subject: Re: Interface for the new fallocate() system call
Date: Fri, 30 Mar 2007 12:44:49 +0200
Message-ID: <20070330104449.GA9371__38020.4174471602$1175295811$gmane$org@lazybastard.org>
References: <20070225022326.137b4875.akpm@linux-foundation.org> <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071929.GC8365@osiris.boeblingen.de.ibm.com> <17932.54606.323431.491736@cargo.ozlabs.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
To: Paul Mackerras <paulus@samba.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lazybastard.de ([212.112.238.170]:59268 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbXC3MlS (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Mar 2007 08:41:18 -0400
Content-Disposition: inline
In-Reply-To: <17932.54606.323431.491736@cargo.ozlabs.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 30 March 2007 19:15:58 +1000, Paul Mackerras wrote:
> Heiko Carstens writes:
>=20
> > If possible I'd prefer the six-32-bit-args approach.
>=20
> It does mean extra unnecessary work for 64-bit platforms, though...

Wouldn't that work be confined to fallocate()?  If I understand Heiko
correctly, the alternative would slow s390 down for every syscall,
including more performance-critical ones.

J=C3=B6rn

--=20
tglx1 thinks that joern should get a (TM) for "Thinking Is Hard"
-- Thomas Gleixner
