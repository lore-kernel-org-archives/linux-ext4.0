From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 00/16] ext4: Add metadata checksumming
Date: Sun, 04 Sep 2011 07:41:03 -0400
Message-ID: <yq1d3fgwn5c.fsf@sermon.lab.mkp.net>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
	<CAGpXXZ+Cq9_aS4BPC5BKNj6aWHzzL7+e8ZQKO3=C7UV+xcnqWA@mail.gmail.com>
	<20110902182214.GC12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
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
To: djwong@us.ibm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110902182214.GC12086@tux1.beaverton.ibm.com> (Darrick
	J. Wong's message of "Fri, 2 Sep 2011 11:22:14 -0700")
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

>>>>> "Darrick" == Darrick J Wong <djwong@us.ibm.com> writes:

Darrick,

Darrick> Furthermore, the nice thing about the in-filesystem checksum is
Darrick> that we bake in other things like the FS UUID and the inode
Darrick> number, which gives you a somewhat better assurance that the
Darrick> data block belongs to the fs and the file that the code think
Darrick> it belongs to.

Yeah, I view DIF/DIX mostly as in-flight protection for writes. Whereas
FS metadata checksumming is great for problem detection at read time.

Another problem with using the DIF app tag to store filesystem metadata
is that many array vendors use it internally and thus only disk drives
are likely to provide the app tag space.


Darrick> The DIX interface allows for a 32-bit block number and a 16-bit
Darrick> application tag ... which is unfortunately small given 64-bit
Darrick> block numbers and 32-bit inode numbers.

I never understood the 32-bit ref tag. Seems silly to have a check that
wraps at the exact boundary where problems are most likely to occur.

I advocated for a DIF Type with 16-bit guard tag and 48-bit ref tag but
that never went anywhere. Too bad - would have been easy for the storage
vendors to implement.


Darrick> As a side note, the crc-t10dif implementation is quite slow --
Darrick> the hardware accelerated crc32c is 15x faster, and the sw
Darrick> implementation is usually 3-6x faster.  I suspect somebody will
Darrick> want to fix that before DIF becomes more widespread...

The CRC32C op on Nehalem and beyond is really, really fast. It's
essentially free except for pulling the data through the cache. So it's
not entirely fair to use that as baseline for a pure software
implementation. What is the faster sw implementation are you referring
to, btw.?

lib/crc-t10dif is a regular 256-entry table-based CRC implementation. It
is done pretty much like all our other software CRCs. I seem to recall
attempting a bigger table but that yielded worse real life results due
to cache pollution.

On Westmere and beyond it is possible to accelerate generic CRC
calculation using the PCLMULQDQ operation. There are many of our CRC
functions that could benefit from this. However, so far intel have not
been willing to contribute the relevant code to Linux.


Darrick> The good news is that if you're really worried about integrity,
Darrick> metadata_csum and DIF/DIX aren't mutually exclusive features.
Darrick> Rejecting corrupted write commands at write time seems like a
Darrick> useful feature. :)

Yup!

-- 
Martin K. Petersen	Oracle Linux Engineering
