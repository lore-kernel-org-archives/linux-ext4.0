From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC][PATCH 1/7]ext4: Add EXT4_IOC_ADD_GLOBAL_ALLOC_RULE	restricts
 block allocation
Date: Wed, 24 Jun 2009 02:11:58 +0200
Message-ID: <20090624001158.GQ31668@webber.adilger.int>
References: <4A409168.3020404@rs.jp.nec.com>
 <20090623231950.GN31668@webber.adilger.int>
 <87f94c370906231702m6dde1402o9d2738f97f4b7df9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-disposition: inline
In-reply-to: <87f94c370906231702m6dde1402o9d2738f97f4b7df9@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Jun 23, 2009  20:02 -0400, Greg Freemyer wrote:
> On Tue, Jun 23, 2009 at 7:19 PM, Andreas Dilger<adilger@sun.com> wrot=
e:
> > On Jun 23, 2009 =A017:25 +0900, Akira Fujita wrote:
> >> alloc_flag of ext4_alloc_rule structure is set as "mandatory" or "=
advisory".
> >> Restricted blocks with "mandatory" are never used by block allocat=
or.
> >> But in "advisory" case, block allocator is allowed to use restrict=
ed blocks
> >> when there are no free blocks on FS.
> >
> > Would it make more sense to implement the range protections via the
> > existing preallocation ranges (PA)? =A0An inode can have multiple
> > PAs attached to it to have it prefer allocations from that range.
> >
> > We could also attach PAs to the superblock to prevent other files f=
rom
> > allocating out of those ranges. =A0This would work better with the =
existing
> > allocation code instead of creating a second similar mechanism.
>=20
> Where can I find documentation about how PA works?  Or is it just in
> the source?  If so, what are one or two calls that cause the PA range=
s
> to be set, etc.

Aneesh is the expert on the preallocation code.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
