From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [RFC] ext4 metadata checksumming design
Date: Thu, 18 Aug 2011 11:14:23 -0700
Message-ID: <20110818181423.GR20655@tux1.beaverton.ibm.com>
References: <20110817032519.GN20655@tux1.beaverton.ibm.com> <EB5DDA28-421A-4C67-817C-74F9B9643351@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Joel Becker <jlbec@evilplan.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Coly Li <colyli@gmail.com>, Andi Kleen <andi@firstfloor.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:42219 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab1HRSOT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Aug 2011 14:14:19 -0400
Content-Disposition: inline
In-Reply-To: <EB5DDA28-421A-4C67-817C-74F9B9643351@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 18, 2011 at 12:16:00AM -0600, Andreas Dilger wrote:
> On 2011-08-16, at 9:25 PM, "Darrick J. Wong" <djwong@us.ibm.com> wrote:
> > - Extended attribute blocks that are stored in the inode table -- the h_magic
> >  field is written by the kernel, but neither the kernel nor e2fsprogs ever
> >  actually read this field.  The field could be reused to checksum the extra
> >  space since (as far as I can tell) EAs are the only user of that empty space.
> 
> I haven't had a chance to read the document you wrote, but wanted to comment
> on xattrs. There is a hash field for each xattr (including internal xattrs),
> and one for the external xattr blocks that can be used to validate the xattr
> value.
> 
> In addition to the hash for the in-inode xattrs, the inode hash itself would
> serve to validate the xattr values. 
> 
> I have a patch for e2fsprogs that checks the xattr hash for in-inode xattrs
> (currently it is always 0).

I surveyed the h_hash/e_hash calculation code; it only covers the name and
value fields.  Do we care about checksum protection for the extra fields in
struct ext4_xattr_header and struct ext4_xattr_entry?  I think it would be
useful to be able to check the sanity of h_refcount and h_blocks.  Possibly
that extends to e_value_* as well, though the hash probably covers it.  Also,
there's no hardware acceleration available for the xattr hash, though I doubt
xattrs are especially performance sensitive.

--D
> 
> > Please have a look at the design document and please feel free to suggest any
> > changes.
> 
> Hopefully soon. 
> 
> Cheers, Andreas--
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
