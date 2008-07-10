From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] ext4: Fix mb_find_next_bit not to return larger than
	max
Date: Thu, 10 Jul 2008 10:12:41 +0530
Message-ID: <20080710044241.GB6764@skywalker>
References: <1215535496-15125-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1215649643.6978.16.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: tytso@mit.edu, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:54508 "EHLO
	e28esmtp07.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752191AbYGJEnH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2008 00:43:07 -0400
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by e28esmtp07.in.ibm.com (8.13.1/8.13.1) with ESMTP id m6A4gn4J002712
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2008 10:12:49 +0530
Received: from d28av03.in.ibm.com (d28av03.in.ibm.com [9.184.220.65])
	by d28relay04.in.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6A4gOZp1278074
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2008 10:12:27 +0530
Received: from d28av03.in.ibm.com (loopback [127.0.0.1])
	by d28av03.in.ibm.com (8.13.1/8.13.3) with ESMTP id m6A4gk8K004964
	for <linux-ext4@vger.kernel.org>; Thu, 10 Jul 2008 10:12:46 +0530
Content-Disposition: inline
In-Reply-To: <1215649643.6978.16.camel@mingming-laptop>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 09, 2008 at 05:27:23PM -0700, Mingming Cao wrote:
>=20
> =E5=9C=A8 2008-07-08=E4=BA=8C=E7=9A=84 22:14 +0530=EF=BC=8CAneesh Kum=
ar K.V=E5=86=99=E9=81=93=EF=BC=9A
> > Some architectures implement ext4_find_next_bit and
> > ext4_find_next_zero_bit in such a way that they return
> > greater than max for some input values. Make sure
> > mb_find_next_bit and mb_find_next_zero_bit return the
> > right values.
> >=20
>=20
> I am not quite clear what bad things happen when  ext4_find_next_bit(=
)
> returns greater than max?   Not sure why we need to force it return
> within the range..
>=20
> Just looking at the code it seems all handles properly that if the
> return > max,  only one is missing is checking in  t ext4_find_next_b=
it
> (),  (as the lustr e patch does), no?


If we return more than max in ext4_mb_generate_buddy we end up with wro=
ng
length for the free block extent. That would mean we could end up
corrupting the file system.

I guess this would be related to that
http://bugzilla.kernel.org/show_bug.cgi?id=3D11053
We don't have a clear reproducer for that bug.=20

The max argument implies that we cannot search beyond max.


>=20
> > On 2.6.25 we have include/asm-x86/bitops_32.h
> > static inline unsigned find_first_bit(const unsigned long *addr, un=
signed size)
> > {
> > 	unsigned x =3D 0;
> >=20
> > 	while (x < size) {
> > 		unsigned long val =3D *addr++;
> > 		if (val)
> > 			return __ffs(val) + x;
> > 		x +=3D (sizeof(*addr)<<3);
> > 	}
> > 	return x;
> > }
> >=20
> > This can return value greater than size.
> >=20
> > Reported and fixed here for lustre
> >=20
> > https://bugzilla.lustre.org/show_bug.cgi?id=3D15932
> > https://bugzilla.lustre.org/attachment.cgi?id=3D17205
> >=20
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/ext4/mballoc.c |   20 ++++++++++++--------
> >  1 files changed, 12 insertions(+), 8 deletions(-)
> >=20
> > diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
> > index a1e58fb..d2c61eb 100644
> > --- a/fs/ext4/mballoc.c
> > +++ b/fs/ext4/mballoc.c
> > @@ -381,22 +381,28 @@ static inline void mb_clear_bit_atomic(spinlo=
ck_t *lock, int bit, void *addr)
> >=20
> >  static inline int mb_find_next_zero_bit(void *addr, int max, int s=
tart)
> >  {
> > -	int fix =3D 0;
> > +	int fix =3D 0, ret, tmpmax;
> >  	addr =3D mb_correct_addr_and_bit(&fix, addr);
> > -	max +=3D fix;
> > +	tmpmax =3D max + fix;
> >  	start +=3D fix;
> >=20
> > -	return ext4_find_next_zero_bit(addr, max, start) - fix;
> > +	ret =3D ext4_find_next_zero_bit(addr, tmpmax, start) - fix;
> > +	if (ret > max)
> > +		return max;
> > +	return ret;
> >  }
> >=20
>=20
> I missed something basic here,  why we need to check ret against the
> tmpmax instead of the max after adjust? (Actually not quite sure why =
we
> need to correct the address in the first place).=20


Some architectures implement ext4_find_next_zero_bit to take unsinged
long pointers. That means the address should be divisible by
sizeof(long). The mb_correct_addr_and_bit just adjust address by moving
it back to an address divisible by sizeof(long). Now that we adjust
address we need to update bit and the max. But in any case we need to
make sure the value returned is not greater than max because rest of th=
e
code assumes and even the API is supposed to guarantee that returned
value is <=3D max.

Instead of auditing all the implementation of ext4_find_next_zero_bit w=
e
just ensures that mb_find_next_zero_bit returns <=3D max.



-aneesh
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
