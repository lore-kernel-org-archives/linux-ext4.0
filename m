From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 03/22] ext4: Record the checksum algorithm in use in the superblock
Date: Wed, 7 Dec 2011 01:40:39 -0700
Message-ID: <949CB89A-7D4D-4429-AB9A-4B43B78D194D@dilger.ca>
References: <20111128232615.19194.80081.stgit@elm3c44.beaverton.ibm.com> <20111128232636.19194.92115.stgit@elm3c44.beaverton.ibm.com> <E0964BB6-793D-49AF-A2B0-20748C6DAE2B@dilger.ca>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
	Theodore Tso <tytso@mit.edu>,
	Amir Goldstein <amir73il@gmail.com>,
	Mingming Cao <cmm@us.ibm.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:28056 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab1LGIkl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Dec 2011 03:40:41 -0500
In-Reply-To: <E0964BB6-793D-49AF-A2B0-20748C6DAE2B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-12-06, at 10:01 PM, Andreas Dilger wrote:
> On 2011-11-28, at 4:26 PM, Darrick J. Wong wrote:
>> Record the type of checksum algorithm we're using for metadata in the
>> superblock, in case we ever want/need to change the algorithm.
>> 
>> @@ -982,6 +982,9 @@ extern void ext4_set_bits(void *bm, int cur, int len);
>> +/* Metadata checksum algorithm codes */
>> +#define EXT4_CRC32C_CHKSUM		1
> 
> It might make sense to add a constant for the existing CRC16 type:
> 
> #define EXT4_CRC16_CHKSUM    0
> #define EXT4_CRC32C_CHKSUM   1
> #define EXT4_CHKSUM_MAX      1

Never mind, I had EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM on the brain.
CRC16 is completely unrelated to EXT4_FEATURE_RO_COMPAT_METADATA_CSUM.

>> +static int ext4_verify_csum_type(struct super_block *sb,
>> +				 struct ext4_super_block *es)
>> +{
>> +	if (!EXT4_HAS_RO_COMPAT_FEATURE(sb,
>> +					EXT4_FEATURE_RO_COMPAT_METADATA_CSUM))
>> +		return 1;
>> +
>> +	return es->s_checksum_type == EXT4_CRC32C_CHKSUM;
>> +}
> 
> Then this checks "return es->s_checksum_type <= EXT4_CHKSUM_MAX;".
> 
>> @@ -3182,6 +3192,14 @@ static int ext4_fill_super(struct super_block *sb, 
>> +	/* Check for a known checksum algorithm */
>> +	if (!ext4_verify_csum_type(sb, es)) {
>> +		ext4_msg(sb, KERN_ERR, "VFS: Found ext4 filesystem with "
>> +			 "unknown checksum algorithm.");
> 
> It would be useful if this error message printed the checksum type.

This is still a valid comment.

Cheers, Andreas





