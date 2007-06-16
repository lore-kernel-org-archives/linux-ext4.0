From: Dmitriy Monakhov <dmonakhov@sw.ru>
Subject: Re: iov_iter_fault_in_readable fix
Date: Sat, 16 Jun 2007 22:17:51 +0400
Message-ID: <20070616181751.GE14349@localhost.sw.ru>
References: <200705292119.l4TLJtAD011726@shell0.pdx.osdl.net> <20070613134005.GA13815@localhost.sw.ru> <20070613135759.GD13815@localhost.sw.ru> <20070614173153.GA14771@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: Christoph Hellwig <hch@infradead.org>,
	linux-kernel@vger.kernel.org, npiggin@suse.de,
	mark.fasheh@oracle.com, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.233.200]:16619 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056AbXFPSSc (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 16 Jun 2007 14:18:32 -0400
Content-Disposition: inline
In-Reply-To: <20070614173153.GA14771@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 18:31 =D0=A7=D1=82=D0=B2 14 =D0=98=D1=8E=D0=BD     , Christoph Hellw=
ig wrote:
> On Wed, Jun 13, 2007 at 05:57:59PM +0400, Dmitriy Monakhov wrote:
> >  	Function prerform check for signgle region, with out respect to
> >  	segment nature of iovec, For example writev no longer works :)
>=20
> Btw, could someone please start to collect all sniplets like this in
> a nice simple regression test suite?  If no one wants to start a new
> one we should probably just put it into xfsqa (which should be useabl=
e
> for other filesystems aswell despite the name)
I've prepared testcase (testcases/kernel/syscalls/writev/writev06.c)=20
and sent it to ltp mailing list.
