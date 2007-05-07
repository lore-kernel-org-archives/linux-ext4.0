From: Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and powerpc
Date: Mon, 07 May 2007 06:08:43 -0700
Message-ID: <463F24DB.5040406@redhat.com>
References: <20070417125514.GA7574@amitarora.in.ibm.com> <20070418130600.GW5967@schatzie.adilger.int> <20070420135146.GA21352@amitarora.in.ibm.com> <20070420145918.GY355@devserv.devel.redhat.com> <20070424121632.GA10136@amitarora.in.ibm.com> <20070426175056.GA25321@amitarora.in.ibm.com> <20070426180332.GA7209@amitarora.in.ibm.com> <20070503212955.b1b6443c.akpm@linux-foundation.org> <20070504060731.GJ32602149@melbourne.sgi.com> <20070503232815.2f62a75e.akpm@linux-foundation.org> <20070504065626.GW355@devserv.devel.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Chinner <dgc@sgi.com>,
	"Amit K. Arora" <aarora@linux.vnet.ibm.com>,
	torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com, suparna@in.ibm.com, cmm@us.ibm.com
To: Jakub Jelinek <jakub@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933771AbXEGNJL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 7 May 2007 09:09:11 -0400
In-Reply-To: <20070504065626.GW355@devserv.devel.redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Jakub Jelinek wrote:
> is what glibc does ATM.  Seems we violate the case where len =3D=3D 0=
, as
> EINVAL in that case is "shall fail".  But reading the standard to imp=
ly
> negative len is ok is too much guessing, there is no word what it mea=
ns
> when len is negative and
> "required storage for regular file data starting at offset and contin=
uing for len bytes"
> doesn't make sense for negative size. =20

This wording has already been cleaned up.  The current draft for the=20
next revision reads:


[EINVAL] The len argument is less than or equal to zero, or the offset
  argument is less than zero, or the underlying file system does not
  support this operation.


I still don't like it since len=3D=3D0 shouldn't create an error (it's=20
inconsistent) but len<0 is already outlawed.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro S=
t =E2=9E=A7 Mountain View, CA =E2=9D=96
