From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC] ext4 metadata checksumming design
Date: Thu, 18 Aug 2011 16:00:40 -0700
Message-ID: <20110818230040.GS20655@tux1.beaverton.ibm.com>
References: <20110817032519.GN20655@tux1.beaverton.ibm.com> <EB5DDA28-421A-4C67-817C-74F9B9643351@dilger.ca> <20110818181423.GR20655@tux1.beaverton.ibm.com> <BD422CF9-E99A-4D31-815D-70C6DABBC6CB@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 List <linux-ext4@vger.kernel.org>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Joel Becker <jlbec@evilplan.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Coly Li <colyli@gmail.com>, Andi Kleen <andi@firstfloor.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54149 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753341Ab1HRXAn (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Aug 2011 19:00:43 -0400
Content-Disposition: inline
In-Reply-To: <BD422CF9-E99A-4D31-815D-70C6DABBC6CB@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 18, 2011 at 03:53:11PM -0600, Andreas Dilger wrote:
> On 2011-08-18, at 12:14 PM, Darrick J. Wong wrote:
> > On Thu, Aug 18, 2011 at 12:16:00AM -0600, Andreas Dilger wrote:
> >> On 2011-08-16, at 9:25 PM, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> >>> - Extended attribute blocks that are stored in the inode table -- the h_magic
> >>> field is written by the kernel, but neither the kernel nor e2fsprogs ever
> >>> actually read this field.  The field could be reused to checksum the extra
> >>> space since (as far as I can tell) EAs are the only user of that empty space.
> >> 
> >> I haven't had a chance to read the document you wrote, but wanted to comment
> >> on xattrs. There is a hash field for each xattr (including internal xattrs),
> >> and one for the external xattr blocks that can be used to validate the xattr
> >> value.
> >> 
> >> In addition to the hash for the in-inode xattrs, the inode hash itself would
> >> serve to validate the xattr values. 
> >> 
> >> I have a patch for e2fsprogs that checks the xattr hash for in-inode xattrs
> >> (currently it is always 0).
> > 
> > I surveyed the h_hash/e_hash calculation code; it only covers the name and
> > value fields.  Do we care about checksum protection for the extra fields in
> > struct ext4_xattr_header and struct ext4_xattr_entry?
> 
> For entries in the inode, the ext4_xattr_entry should itself already be
> covered by the inode hash.

Based on your comments and other discoveries I've made today, I'm leaning
towards extending the inode crc to cover the extra space instead of dealing
with a new EA magic.  I think the kernel is trivially ok with that; e2fsprogs,
however, seems to contain some assumptions about memory allocation and IO sizes
(it thinks it can get away with having on-stack ext2_inode variables) but since
I'm already tearing up a lot of that code, I can make it deal with a few more
bytes, say up to s_inode_size.

> For entries in an external EA block, the ext4_xattr_header h_hash only
> contains the hash of individual e_hash values, themselves covering the
> e_name and e_value parts of the structure.
> 
> This is by design since the h_hash is used to determine whether an xattr
> block can be shared among inodes (mbcache, which I'm not a fan of, but
> that is besides the point) so it should depend only on the content and
> not the actual layout (e.g. cannot contain e_value_offs, e_value_block,
> h_refcount, h_blocks).
> 
> 
> I'm totally against using the h_magic field for a checksum, since it would
> break our ability to change the structure of xattrs in the future.  Instead,
> it would be possible to use a new h_magic (e.g. EA03) that redefines the hash
> function to be what we want it to be (e.g. e_hash is CRC32c of everything
> except e_value_offs and e_hash, and h_hash is CRC32c of all e_hash fields),
> without making the code significantly more complex.

Sorry, I misread the code and thought the inode EA h_magic wasn't ever being
checked.  I looked again today, and it does, so I'm against (ab)using h_magic
also.  I'll just figure out how to make the inode checksum cover the extra
space.  For the separate EA blocks, I'll just use h_reserved[0].  It's probably
easier just to crc32c the whole block, though if it's a performance problem I
can always change it before it goes upstream.  The extra code complexity of
finding the not-covered-by-hash fields probably isn't worthwhile on an
attribute block.

> That would firstly give us a better hash function for the entries, and
> secondly add in the e_name_len, e_name_index, and e_value_size values into
> e_hash (and subsequently into h_hash).
> 
> We could also/instead use h_reserved[0] for a hash of ext4_xattr_header
> and the missing e_* fields to have a stronger validation of the entire block,
> without breaking the ability to use h_hash as a hash of the content, and
> without doubling the CPU cost of doing the checksum.
> 
> Alternately, if we want to spend the extra CPU cycles, it would be possible
> to just use h_reserved[0] for a CRC32c (or other) checksum of the whole
> block.
> 
> Using only h_reserved[0] instead of changing h_magic would not require
> changing the h_magic at all (which would break read-only compatibility).

Thank you for the comments!

--D
