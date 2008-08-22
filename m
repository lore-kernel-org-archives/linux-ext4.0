From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH] percpu_counters: make fbc->count read atomic on 32
	bit architecture
Date: Fri, 22 Aug 2008 20:33:22 +0200
Message-ID: <1219430002.21326.22.camel@lappy.programming.kicks-ass.net>
References: <1219412074-30584-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <1219429794.6306.34.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:38463 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758193AbYHVSeM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 22 Aug 2008 14:34:12 -0400
In-Reply-To: <1219429794.6306.34.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, 2008-08-22 at 11:29 -0700, Mingming Cao wrote:
> =E5=9C=A8 2008-08-22=E4=BA=94=E7=9A=84 19:04 +0530=EF=BC=8CAneesh Kum=
ar K.V=E5=86=99=E9=81=93=EF=BC=9A
> > fbc->count is of type s64. The change was introduced by
> > 0216bfcffe424a5473daa4da47440881b36c1f4 which changed the type
> > from long to s64. Moving to s64 also means on 32 bit architectures
> > we can get wrong values on fbc->count.
> >=20
> > percpu_counter_read is used within interrupt context also. So
> > use the irq safe version of spinlock while reading
> >=20
>=20
> It's quit expensive to hold the lock to do percpu_counter_read  on 32
> bit arch, the common case.
> =20
> The type of the global counter and local counter were explictly
> specified using s64 and s32 The global counter is changed from long t=
o
> s64, while the local counter is changed from long to s32, so we could
> avoid doing 64 bit update in most cases.  After all the percpu counte=
r
> read is not a accurate value.=20

seqlocks come to mind.

--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
