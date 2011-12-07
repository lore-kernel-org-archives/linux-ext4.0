From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 03/22] ext4: Record the checksum algorithm in use in
	the superblock
Date: Tue, 6 Dec 2011 23:42:57 -0800
Message-ID: <20111207074257.GJ7137@tux1.beaverton.ibm.com>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com> <20111128232636.19194.92115.stgit@elm3c44.beaverton.ibm.com> <E0964BB6-793D-49AF-A2B0-20748C6DAE2B@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Tso <tytso@mit.edu>,
	Sunil Mushran <sunil.mushran@oracle.com>,
	Martin K Petersen <martin.petersen@oracle.com>,
	Greg Freemyer <greg.freemyer@gmail.com>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Andi Kleen <andi@firstfloor.org>,
	Mingming Cao <cmm@us.ibm.com>,
	Joel Becker <jlbec@evilplan.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	linux-ext4@vger.kernel.org, Coly Li <colyli@gmail.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:43740 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab1LGHnm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Dec 2011 02:43:42 -0500
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-ext4@vger.kernel.org> from <djwong@us.ibm.com>;
	Wed, 7 Dec 2011 00:43:41 -0700
Content-Disposition: inline
In-Reply-To: <E0964BB6-793D-49AF-A2B0-20748C6DAE2B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Dec 06, 2011 at 10:01:35PM -0700, Andreas Dilger wrote:
> On 2011-11-28, at 4:26 PM, Darrick J. Wong wrote:
> > Record the type of checksum algorithm we're using for metadata in the
> > superblock, in case we ever want/need to change the algorithm.
> > 
> > @@ -982,6 +982,9 @@ extern void ext4_set_bits(void *bm, int cur, int len);
> > +/* Metadata checksum algorithm codes */
> > +#define EXT4_CRC32C_CHKSUM		1
> 
> It might make sense to add a constant for the existing CRC16 type:
> 
> #define EXT4_CRC16_CHKSUM    0
> #define EXT4_CRC32C_CHKSUM   1
> #define EXT4_CHKSUM_MAX      1

I disagree -- this field is only defined if metadata_csum is set, and most of
the checksumming code doesn't know what crc16 is.  If a user somehow set the
checksum type to "crc16", the code would keep using crc32c.  

If we ever extend ext4_chksum() to support other algorithms I suppose we could
make it smart enough to switch algorithms based on the field setting, but I
don't really want to do for crc16. :)

> > +static int ext4_verify_csum_type(struct super_block *sb,
> > +				 struct ext4_super_block *es)
> > +{
> > +	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
> > +					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
> > +		return 1;
> > +
> > +	return es->s_checksum_type == EXT4_CRC32C_CHKSUM;
> > +}
> 
> Then this checks "return es->s_checksum_type <= EXT4_CHKSUM_MAX;".

Not really -- this would allow us to mount a file system with metadata_csum=1
and csum_type=crc16, and crc16 is not supported by most of the checksumming
code.  I'd rather have the code reject the mount and send fs in for fsck, since
crc32c is the only one it knows about.

> > @@ -3182,6 +3192,14 @@ static int ext4_fill_super(struct super_block *sb, 
> > +	/* Check for a known checksum algorithm */
> > +	if (!ext4_verify_csum_type(sb, es)) {
> > +		ext4_msg(sb, KERN_ERR, "VFS: Found ext4 filesystem with "
> > +			 "unknown checksum algorithm.");
> 
> It would be useful if this error message printed the checksum type.

Agreed.

--D
> 
> Cheers, Andreas
> 
> 
> 
> 
> 

