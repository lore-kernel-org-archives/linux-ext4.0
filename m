From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH 01/02] ext2: reserve INCOMPAT_INLINEDATA feature flag
Date: Wed, 07 Dec 2011 18:14:23 +0800
Message-ID: <4EDF3C7F.4090801@tao.ma>
References: <BC7EBC84-486E-4BD5-A952-51C2B71BF455@whamcloud.com> <E8BB5200-9BE3-49FE-AFC2-18B2E7BBA5A8@whamcloud.com> <20111207003932.GI7137@tux1.beaverton.ibm.com> <D24AD8E4-9B72-4518-9CC9-99FBB143BB62@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: djwong@us.ibm.com, Theodore Ts'o <tytso@mit.edu>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Liang Zhen <liang@whamcloud.com>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from oproxy9.bluehost.com ([69.89.24.6]:60396 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753803Ab1LGKOc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 7 Dec 2011 05:14:32 -0500
In-Reply-To: <D24AD8E4-9B72-4518-9CC9-99FBB143BB62@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 12/07/2011 05:45 PM, Andreas Dilger wrote:
> On 2011-12-06, at 5:39 PM, Darrick J. Wong wrote:
>> On Tue, Dec 06, 2011 at 05:13:51PM -0700, Andreas Dilger wrote:
>>> +#define EXT4_FEATURE_INCOMPAT_INLINEDATA	0x2000 /* data in inode */
>>
>> I was using 0x2000 for EXT4_FEATURE_INCOMPAT_BG_USE_META_CSUM, to change
>> the block group checksum to use crc32c.
> 
> I didn't see that...  I was looking at your patch and only noticed
> EXT4_FEATURE_RO_COMPAT_METADATA_CSUM.  I suspect your patch is closer
> to landing it is better to use the 0x2000 value for BG_USE_META_CSUM,
> and change the value for INLINEDATA to 0x8000 instead.
OK, I will use this number for inline data for the new version if there
is no objection.

Thanks
Tao
