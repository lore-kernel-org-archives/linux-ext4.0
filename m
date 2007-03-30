From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: Interface for the new fallocate() system call
Date: Fri, 30 Mar 2007 14:55:38 +0200
Message-ID: <20070330125538.GE8365@osiris.boeblingen.de.ibm.com>
References: <20070301183445.GA7911@amitarora.in.ibm.com> <20070316143101.GA10152@amitarora.in.ibm.com> <20070316161704.GE8525@osiris.boeblingen.de.ibm.com> <20070317111036.GC29931@parisc-linux.org> <20070321120425.GA27273@amitarora.in.ibm.com> <20070329115126.GB7374@amitarora.in.ibm.com> <20070329101010.7a2b8783.akpm@linux-foundation.org> <20070330071929.GC8365@osiris.boeblingen.de.ibm.com> <17932.54606.323431.491736@cargo.ozlabs.ibm.com> <20070330104449.GA9371@lazybastard.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Paul Mackerras <paulus@samba.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:1587 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbXC3Mzm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 Mar 2007 08:55:42 -0400
Content-Disposition: inline
In-Reply-To: <20070330104449.GA9371@lazybastard.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, Mar 30, 2007 at 12:44:49PM +0200, J=F6rn Engel wrote:
> On Fri, 30 March 2007 19:15:58 +1000, Paul Mackerras wrote:
> > It does mean extra unnecessary work for 64-bit platforms, though...
>=20
> Wouldn't that work be confined to fallocate()?  If I understand Heiko
> correctly, the alternative would slow s390 down for every syscall,
> including more performance-critical ones.

That is correct.
