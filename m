From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH 1/7]ext4: Add EXT4_IOC_ADD_GLOBAL_ALLOC_RULE
	restricts block allocation
Date: Sat, 27 Jun 2009 22:24:00 +0530
Message-ID: <20090627165400.GA9414@skywalker>
References: <4A409168.3020404@rs.jp.nec.com> <20090623231950.GN31668@webber.adilger.int> <87f94c370906231702m6dde1402o9d2738f97f4b7df9@mail.gmail.com> <20090624001158.GQ31668@webber.adilger.int> <87f94c370906250547l338fd357s2e51291185bc3b2c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Andreas Dilger <adilger@sun.com>,
	Akira Fujita <a-fujita@rs.jp.nec.com>,
	linux-ext4@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org,
	Aneesh Kumar <aneesh.kumar@gmail.com>
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87f94c370906250547l338fd357s2e51291185bc3b2c@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 25, 2009 at 08:47:59AM -0400, Greg Freemyer wrote:
> Aneesh,
>=20
> Can you provide the below requested info?
>=20
> Thanks
> Greg
>=20
> On Tue, Jun 23, 2009 at 8:11 PM, Andreas Dilger<adilger@sun.com> wrot=
e:
> > On Jun 23, 2009 =A020:02 -0400, Greg Freemyer wrote:
> >> On Tue, Jun 23, 2009 at 7:19 PM, Andreas Dilger<adilger@sun.com> w=
rote:
> >> > On Jun 23, 2009 =A017:25 +0900, Akira Fujita wrote:
> >> >> alloc_flag of ext4_alloc_rule structure is set as "mandatory" o=
r "advisory".
> >> >> Restricted blocks with "mandatory" are never used by block allo=
cator.
> >> >> But in "advisory" case, block allocator is allowed to use restr=
icted blocks
> >> >> when there are no free blocks on FS.
> >> >
> >> > Would it make more sense to implement the range protections via =
the
> >> > existing preallocation ranges (PA)? =A0An inode can have multipl=
e
> >> > PAs attached to it to have it prefer allocations from that range=
=2E
> >> >
> >> > We could also attach PAs to the superblock to prevent other file=
s from
> >> > allocating out of those ranges. =A0This would work better with t=
he existing
> >> > allocation code instead of creating a second similar mechanism.
> >>
> >> Where can I find documentation about how PA works? =A0Or is it jus=
t in
> >> the source? =A0If so, what are one or two calls that cause the PA =
ranges
> >> to be set, etc.
> >

Mostly the source. Some of mballoc details are documented in the ols
2008 paper. Regarding some of the functions

ext4_mb_use_preallocated -> allocate from PA
ext4_mb_new_preallocation -> Create new PA.

Source code also have some documentation that explains how mballoc use
PA.

-aneesh
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
