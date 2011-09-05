From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 08/16] ext4: Calculate and verify checksums for inode
 bitmaps
Date: Mon, 05 Sep 2011 14:45:28 -0500
Message-ID: <1315251928.15087.74.camel@dabdike.int.hansenpartnership.com>
References: <20110901003030.31048.99467.stgit@elm3c44.beaverton.ibm.com>
	 <20110901003127.31048.13983.stgit@elm3c44.beaverton.ibm.com>
	 <2A834E5A-F07E-4B1E-835B-FBEE3FD7A103@dilger.ca>
	 <20110902191828.GL12086@tux1.beaverton.ibm.com>
	 <8D646179-FD76-4362-A051-8C6ADB3CE1B3@dilger.ca>
	 <20110905182250.GO12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
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
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110905182250.GO12086@tux1.beaverton.ibm.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2011-09-05 at 11:22 -0700, Darrick J. Wong wrote:
> On Fri, Sep 02, 2011 at 03:27:21PM -0600, Andreas Dilger wrote:
> > On 2011-09-02, at 1:18 PM, Darrick J. Wong wrote:
> > > On Wed, Aug 31, 2011 at 10:49:05PM -0600, Andreas Dilger wrote:
> > >> On 2011-08-31, at 6:31 PM, Darrick J. Wong wrote:
> > >>> Compute and verify the checksum of the inode bitmap; the checkum is stored in
> > >>> the block group descriptor.
> > >> 
> > >> I would prefer if there was a 16-bit checksum for the (most common)
> > >> 32-byte group descriptors, and this was extended to a 32-bit checksum
> > >> for the (much less common) 64-byte+ group descriptors.  For filesystems
> > >> that are newly formatted with the 64bit feature it makes no difference,
> > >> but virtually all ext3/4 filesystems have only the smaller group descriptors.
> > >> 
> > >> Regardless of whether using half of the crc32c is better or worse than
> > >> using crc16 for the bitmap blocks, storing _any_ checksum is better than
> > >> storing nothing at all.  I would propose the following:
> > > 
> > > That's an interesting reframing of the argument that I hadn't considered.
> > > I'd fallen into the idea of needing crc32c because of its bit error
> > > guarantees (all corruptions of odd numbers of bits and all corruptions of
> > > fewer than ...4? bits) that I hadn't quite realized that even if crc16
> > > can't guarantee to find any corruption at all, it still _might_, and that's
> > > better than nothing.
> > > 
> > > Ok, let's split the 32-bit fields and use crc16 for the case of 32-byte block
> > > group descriptors.
> > 
> > I noticed the crc16 calculation is actually _slower_ than crc32c,
> > probably because the CPU cannot use 32-bit values when computing the
> > result, so it has to do a lot of word masking, per your table at
> > https://ext4.wiki.kernel.org/index.php/Ext4_Metadata_Checksums.
> > Also, there is the question of whether computing two different
> > checksums is needlessly complicating the code, or if it is easier
> > to just compute crc32c all the time and only make the storing of
> > the high 16 bits conditional.
> > 
> > What I'm suggesting is always computing the crc32c, but for filesystems
> > that are not formatted with the 64bit option just store the low 16 bits
> > of the crc32c value into bg_{block,inode}_bitmap_csum_lo.  This is much
> > better than not computing a checksum here at all.  The only open question
> > is whether 1/2 of crc32c is substantially worse at detecting errors than
> > crc16 or not?
> 
> All the literature I've read has suggested that crc16 can't guarantee any error
> detection capability at all with data buffers longer than 256 bytes.

Um, so in a hashing algorithm that maps f:Z_m -> Z_n you can never
guarantee error detection if m>n because of hash collisions.  All you
can guarantee is that if f(a) != f(b) then a != b, so crc16 wouldn't be
able to *guarantee* error detection in anything over 2 bytes.

All of the rest of the magic in hashing functions goes into making sure
that the collision sets don't include common errors (like bit flipping).
In theory, for the correct polynomial, CRC-16 should be able to detect
single, double and triple bit flip errors in blocks of up to 8191
bytes ... of course, if those aren't your common errors, then this
analysis is useless ...

James


