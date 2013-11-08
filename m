From: "Dilger, Andreas" <andreas.dilger@intel.com>
Subject: Re: [PATCH] ext4: return non-zero st_blocks for inline data
Date: Fri, 8 Nov 2013 12:25:30 +0000
Message-ID: <CEA2256B.7F605%andreas.dilger@intel.com>
References: <20131108034504.GC11668@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:15010 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851Ab3KHMZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Nov 2013 07:25:46 -0500
In-Reply-To: <20131108034504.GC11668@thunk.org>
Content-Language: en-US
Content-ID: <F6EF47581A394A4397A9E6C016DA3A95@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013/11/07 8:45 PM, "Theodore Ts'o" <tytso@mit.edu> wrote:

>On Wed, Nov 06, 2013 at 03:42:32AM -0700, Andreas Dilger wrote:
>> @@ -4542,9 +4551,9 @@ int ext4_getattr(struct vfsmount *mnt, struct
>>dentry *dentry,
>>  	 * blocks for this file.
>>  	 */
>>  	delalloc_blocks = EXT4_C2B(EXT4_SB(inode->i_sb),
>> -				EXT4_I(inode)->i_reserved_data_blocks);
>> +				   EXT4_I(inode)->i_reserved_data_blocks);
>> +	stat->blocks += delalloc_blocks << (inode->i_sb->s_blocksize_bits -
>>9);
>>  
>> -	stat->blocks += (delalloc_blocks << inode->i_sb->s_blocksize_bits)>>9;
>
>Why this change to the calculation to stat->blocks?

Just code cleanup.  The lack of spaces around ">>9" irked me.

The calculation is the same (s_blocksize_bits can never be less than 10
for ext* filesystems), but avoids doing two separate shifts that the
compiler cannot optimize together due to parenthesis and potential side
effects (e.g. this kind of operation could be used to mask off the top
bits, but isn't doing so here).

Cheers, Andreas
-- 
Andreas Dilger

Lustre Software Architect
Intel High Performance Data Division


