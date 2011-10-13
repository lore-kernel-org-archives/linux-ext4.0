From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 11/28] ext4: Calculate and verify inode checksums
Date: Wed, 12 Oct 2011 18:02:21 -0600
Message-ID: <ADB8AAAD-4422-4FD1-99BF-3E2A15C80BBB@dilger.ca>
References: <20111008075343.20506.23155.stgit@elm3c44.beaverton.ibm.com> <20111008075456.20506.47319.stgit@elm3c44.beaverton.ibm.com> <1CCC75F1-41BE-49E9-8A03-372FC76E0202@dilger.ca> <20111012210342.GO12447@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
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
To: djwong@us.ibm.com
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20111012210342.GO12447@tux1.beaverton.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 2011-10-12, at 3:03 PM, Darrick J. Wong wrote:
> On Wed, Oct 12, 2011 at 12:45:01PM -0700, Andreas Dilger wrote:
>>> +static __u32 ext4_inode_csum(struct inode *inode, struct ext4_inode *raw,
>>> +			      struct ext4_inode_info *ei)
>>> +{
>>> +	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
>>> +	__u16 crc_lo;
>>> +	__u16 crc_hi = 0;
>>> +	__u32 crc;
>>> +
>>> +	crc_lo = raw->i_checksum_lo;
>>> +	raw->i_checksum_lo = 0;
>>> +	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
>>> +	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi)) {
>>> +		crc_hi = raw->i_checksum_hi;
>>> +		raw->i_checksum_hi = 0;
>>> +	}
>>> +
>>> +	crc = ext4_chksum(sbi, ei->i_uuid_inum_crc, (__u8 *)raw,
>>> +			  EXT4_INODE_SIZE(inode->i_sb));
>>> +
>>> +	raw->i_checksum_lo = crc_lo;
>>> +	if (EXT4_INODE_SIZE(inode->i_sb) > EXT4_GOOD_OLD_INODE_SIZE &&
>>> +	    EXT4_FITS_IN_INODE(raw, ei, i_checksum_hi))
>>> +		raw->i_checksum_hi = crc_hi;
>>> +
>>> +	return crc;
>>> +}
>> 
>> This computes both the _lo and _hi parts of the checksum and overwrites
>> what is in the inode...
> 
> I don't follow your logic ... for the _lo component, first I save the old
> i_checksum_lo contents in crc_lo.  Then I stuff zero into i_checksum_lo.
> Next I perform the checksum computation (with the checksum field
> effectively "zero") and put the results into crc.  Then I copy whatever
> I saved in crc_lo back into i_checksum_lo.
> 
> crc_lo, crc_hi, and crc are three separate variables, and neither crc_lo
> nor crc_hi are ever assigned any part of crc.  Therefore crc_lo and
> crc_hi should always contain the old checksum contents.
> 
> Did I miss something?  Afaict the contents of raw should be the same
> before and after the call to ext4_inode_csum(), but maybe I've been
> looking at this too long. :)

No, you are right.  I misread the code and thought that crc_lo and crc_hi
were derived from the computed value.

Cheers, Andreas
