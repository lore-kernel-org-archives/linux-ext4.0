From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH v1 00/16] ext4: Add metadata checksumming
Date: Mon, 5 Sep 2011 11:45:24 -0700
Message-ID: <20110905184524.GQ12086@tux1.beaverton.ibm.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com> <CAGpXXZ+Cq9_aS4BPC5BKNj6aWHzzL7+e8ZQKO3=C7UV+xcnqWA@mail.gmail.com> <20110902182214.GC12086@tux1.beaverton.ibm.com> <yq1d3fgwn5c.fsf@sermon.lab.mkp.net>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43468 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab1IESpd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Sep 2011 14:45:33 -0400
Content-Disposition: inline
In-Reply-To: <yq1d3fgwn5c.fsf@sermon.lab.mkp.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 04, 2011 at 07:41:03AM -0400, Martin K. Petersen wrote:
> >>>>> "Darrick" == Darrick J Wong <djwong@us.ibm.com> writes:
> 
> Darrick,
> 
> Darrick> Furthermore, the nice thing about the in-filesystem checksum is
> Darrick> that we bake in other things like the FS UUID and the inode
> Darrick> number, which gives you a somewhat better assurance that the
> Darrick> data block belongs to the fs and the file that the code think
> Darrick> it belongs to.
> 
> Yeah, I view DIF/DIX mostly as in-flight protection for writes. Whereas
> FS metadata checksumming is great for problem detection at read time.
> 
> Another problem with using the DIF app tag to store filesystem metadata
> is that many array vendors use it internally and thus only disk drives
> are likely to provide the app tag space.
> 
> 
> Darrick> The DIX interface allows for a 32-bit block number and a 16-bit
> Darrick> application tag ... which is unfortunately small given 64-bit
> Darrick> block numbers and 32-bit inode numbers.
> 
> I never understood the 32-bit ref tag. Seems silly to have a check that
> wraps at the exact boundary where problems are most likely to occur.
> 
> I advocated for a DIF Type with 16-bit guard tag and 48-bit ref tag but
> that never went anywhere. Too bad - would have been easy for the storage
> vendors to implement.

> 
> 
> Darrick> As a side note, the crc-t10dif implementation is quite slow --
> Darrick> the hardware accelerated crc32c is 15x faster, and the sw
> Darrick> implementation is usually 3-6x faster.  I suspect somebody will
> Darrick> want to fix that before DIF becomes more widespread...
> 
> The CRC32C op on Nehalem and beyond is really, really fast. It's
> essentially free except for pulling the data through the cache. So it's
> not entirely fair to use that as baseline for a pure software
> implementation. What is the faster sw implementation are you referring
> to, btw.?

I have some benchmarking data for various crc algorithms here:
https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums#Benchmarking

The "faster sw implementation" that I was talking about is the slice-by-8
algorithm that I sent to the crypto list a few days ago that's based off of Bob
Pearson's slice-by-8 crc32 patch.

In the huge table, "crc32c-by8-le" is crc32c slice-by-8.

> lib/crc-t10dif is a regular 256-entry table-based CRC implementation. It
> is done pretty much like all our other software CRCs. I seem to recall
> attempting a bigger table but that yielded worse real life results due
> to cache pollution.

Yes, the only downside to the slice-by-8 method is that it eats 8K of data
cache for the table.  Not a huge issue on recent Intel and POWER where the L1D
is 32K, but I imagine it could be painful elsewhere.

Do you know of any faster crc16 algorithms?  I guess it wouldn't be hard to
make a family of crcs, each with different cache/speed characteristics.

> On Westmere and beyond it is possible to accelerate generic CRC
> calculation using the PCLMULQDQ operation. There are many of our CRC
> functions that could benefit from this. However, so far intel have not
> been willing to contribute the relevant code to Linux.
> 
> 
> Darrick> The good news is that if you're really worried about integrity,
> Darrick> metadata_csum and DIF/DIX aren't mutually exclusive features.
> Darrick> Rejecting corrupted write commands at write time seems like a
> Darrick> useful feature. :)
> 
> Yup!
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
