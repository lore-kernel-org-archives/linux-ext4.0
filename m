From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [RFC] Heads up on sys_fallocate()
Date: Sat, 3 Mar 2007 23:45:32 +0100
Message-ID: <200703032345.33137.arnd@arndb.de>
References: <20070117094658.GA17390@amitarora.in.ibm.com> <1172789056.11165.42.camel@kleikamp.austin.ibm.com> <20070301233819.GB31072@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, suparna@in.ibm.com, cmm@us.ibm.com,
	alex@clusterfs.com, suzuki@in.ibm.com,
	Ulrich Drepper <drepper@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.179]:50121 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030519AbXCCWpl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 3 Mar 2007 17:45:41 -0500
In-Reply-To: <20070301233819.GB31072@infradead.org>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Friday 02 March 2007 00:38:19 Christoph Hellwig wrote:
> > Forgive me if I haven't put enough thought into it, but would it be
> > useful to create a generic_fallocate() that writes zeroed pages for=
 any
> > non-existent pages in the range? =A0I don't know how glibc currentl=
y
> > implements posix_fallocate(), but maybe the kernel could do it more
> > efficiently, even in generic code. =A0Maybe we don't care, since th=
e major
> > file systems can probably do something better in their own code.
>
> I'd be more happy to have the write out zeroes loop in glibc. =A0And
> glibc needs to have it anyway, for older kernels.

A generic_fallocate makes sense to me iff we can do it in the kernel
more significantly more efficiently than in glibc, e.g. by using only
a single page in page cache instead of one for each page to be prealloc=
ated.

If  glibc is smart enough to do an optimal implementation, I fully agre=
e
with you.

	Arnd <><
