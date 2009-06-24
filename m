From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: [RFC][PATCH 1/7]ext4: Add EXT4_IOC_ADD_GLOBAL_ALLOC_RULE
	restricts block allocation
Date: Tue, 23 Jun 2009 20:02:55 -0400
Message-ID: <87f94c370906231702m6dde1402o9d2738f97f4b7df9@mail.gmail.com>
References: <4A409168.3020404@rs.jp.nec.com>
	 <20090623231950.GN31668@webber.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Akira Fujita <a-fujita@rs.jp.nec.com>, linux-ext4@vger.kernel.org,
	"Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org
To: Andreas Dilger <adilger@sun.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20090623231950.GN31668@webber.adilger.int>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 23, 2009 at 7:19 PM, Andreas Dilger<adilger@sun.com> wrote:
> On Jun 23, 2009 =A017:25 +0900, Akira Fujita wrote:
>> alloc_flag of ext4_alloc_rule structure is set as "mandatory" or "ad=
visory".
>> Restricted blocks with "mandatory" are never used by block allocator=
=2E
>> But in "advisory" case, block allocator is allowed to use restricted=
 blocks
>> when there are no free blocks on FS.
>
> Would it make more sense to implement the range protections via the
> existing preallocation ranges (PA)? =A0An inode can have multiple
> PAs attached to it to have it prefer allocations from that range.
>
> We could also attach PAs to the superblock to prevent other files fro=
m
> allocating out of those ranges. =A0This would work better with the ex=
isting
> allocation code instead of creating a second similar mechanism.
>
> Cheers, Andreas

Andreas,

Where can I find documentation about how PA works?  Or is it just in
the source?  If so, what are one or two calls that cause the PA ranges
to be set, etc.

Thanks
Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
=46irst 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.p=
df

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-fsdevel=
" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
