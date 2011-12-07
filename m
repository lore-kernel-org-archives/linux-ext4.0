From: Andreas Dilger <adilger@whamcloud.com>
Subject: Re: [PATCH 01/02] ext2: reserve INCOMPAT_INLINEDATA feature flag
Date: Wed, 7 Dec 2011 02:45:04 -0700
Message-ID: <D24AD8E4-9B72-4518-9CC9-99FBB143BB62@whamcloud.com>
References: <BC7EBC84-486E-4BD5-A952-51C2B71BF455@whamcloud.com> <E8BB5200-9BE3-49FE-AFC2-18B2E7BBA5A8@whamcloud.com> <20111207003932.GI7137@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Liang Zhen <liang@whamcloud.com>, Tao Ma <tm@tao.ma>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44175 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab1LGJpH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Dec 2011 04:45:07 -0500
Received: by yenm1 with SMTP id m1so300238yen.19
        for <linux-ext4@vger.kernel.org>; Wed, 07 Dec 2011 01:45:07 -0800 (PST)
In-Reply-To: <20111207003932.GI7137@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-12-06, at 5:39 PM, Darrick J. Wong wrote:
> On Tue, Dec 06, 2011 at 05:13:51PM -0700, Andreas Dilger wrote:
>> +#define EXT4_FEATURE_INCOMPAT_INLINEDATA	0x2000 /* data in inode */
> 
> I was using 0x2000 for EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM, to change
> the block group checksum to use crc32c.

I didn't see that...  I was looking at your patch and only noticed
EXT4_FEATURE_RO_COMPAT_METADATA_CSUM.  I suspect your patch is closer
to landing it is better to use the 0x2000 value for BG_USE_META_CSUM,
and change the value for INLINEDATA to 0x8000 instead.

Cheers, Andreas
--
Andreas Dilger 
Principal Engineer
Whamcloud, Inc.



