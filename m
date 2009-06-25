From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [RFC][PATCH 1/7]ext4: Add EXT4_IOC_ADD_GLOBAL_ALLOC_RULE
	restricts block allocation
Date: Thu, 25 Jun 2009 08:47:59 -0400
Message-ID: <87f94c370906250547l338fd357s2e51291185bc3b2c@mail.gmail.com>
References: <4A409168.3020404@rs.jp.nec.com>
	 <20090623231950.GN31668@webber.adilger.int>
	 <87f94c370906231702m6dde1402o9d2738f97f4b7df9@mail.gmail.com>
	 <20090624001158.GQ31668@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org,
	Aneesh Kumar <aneesh.kumar@gmail.com>
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090624001158.GQ31668@webber.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Aneesh,

Can you provide the below requested info?

Thanks
Greg

On Tue, Jun 23, 2009 at 8:11 PM, Andreas Dilger<adilger@sun.com> wrote:
> On Jun 23, 2009 =A020:02 -0400, Greg Freemyer wrote:
>> On Tue, Jun 23, 2009 at 7:19 PM, Andreas Dilger<adilger@sun.com> wro=
te:
>> > On Jun 23, 2009 =A017:25 +0900, Akira Fujita wrote:
>> >> alloc_flag of ext4_alloc_rule structure is set as "mandatory" or =
"advisory".
>> >> Restricted blocks with "mandatory" are never used by block alloca=
tor.
>> >> But in "advisory" case, block allocator is allowed to use restric=
ted blocks
>> >> when there are no free blocks on FS.
>> >
>> > Would it make more sense to implement the range protections via th=
e
>> > existing preallocation ranges (PA)? =A0An inode can have multiple
>> > PAs attached to it to have it prefer allocations from that range.
>> >
>> > We could also attach PAs to the superblock to prevent other files =
from
>> > allocating out of those ranges. =A0This would work better with the=
 existing
>> > allocation code instead of creating a second similar mechanism.
>>
>> Where can I find documentation about how PA works? =A0Or is it just =
in
>> the source? =A0If so, what are one or two calls that cause the PA ra=
nges
>> to be set, etc.
>
> Aneesh is the expert on the preallocation code.
>
> Cheers, Andreas
> --
> Andreas Dilger
> Sr. Staff Engineer, Lustre Group
> Sun Microsystems of Canada, Inc.
>
>



--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
Preservation and Forensic processing of Exchange Repositories White Pap=
er -
http://www.norcrossgroup.com/forms/whitepapers/Forensic%20Processing%20=
of%20Exchange%20WP%20final.pdf

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
