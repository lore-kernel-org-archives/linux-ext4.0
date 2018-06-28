From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRD?=
 =?utf-8?Q?H=5D_ext4=3A_e2fsprogs=3A_fix_inode_bitma?= =?utf-8?Q?p?= num not
 integer,incompatible for ancient android devices
Date: Thu, 28 Jun 2018 11:30:22 -0400
Message-ID: <20180628153022.GA8521@thunk.org>
References: <1530014046-62466-1-git-send-email-gaoming20@huawei.com>
 <20180627140937.GA3348@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC41667@dggemm511-mbx.china.huawei.com>
 <20180628022900.GA663@thunk.org>
 <FDC91B229D965C458E3615E98C48ADDD0EC416E8@dggemm511-mbx.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Liqingchao (sorp)" <sorp.liqingchao@huawei.com>,
        "Shenchen (harry)" <harry.shen@huawei.com>,
        "miaoxie (A)" <miaoxie@huawei.com>,
        "yangfei (D)" <yangfei39@huawei.com>,
        "Renlipeng (OS driver)" <renlipeng@huawei.com>
To: "Gaoming (ming, consumer BG)" <gaoming20@huawei.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <FDC91B229D965C458E3615E98C48ADDD0EC416E8@dggemm511-mbx.china.huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jun 28, 2018 at 07:56:59AM +0000, Gaoming (ming, consumer BG) wrote:
> You see, Inodes per group is 1708,which is illegal as you said.
> 
> So, the problem exists a long time until Jun 21th 2018.
> 
> You complained the problem in 2011, they do not fix it till 2018.
> Just as
> I complained, fix it,  and you do not accept it. ^_^

Here's the commit.  (Note the date.)   Do you see it in your repository?

Or are you using an unusual inode size?  (e.g., not 256 bytes, or 16
inodes per block).


       	   	       	       	     	  - Ted

commit 06c35f935a7adadceb9ee326b3231f952f6ad203
Merge: 480a3b1 96cc54a
Author: Colin Cross <ccross@android.com>
Date:   Sat Apr 30 19:08:09 2011 -0700

    Merge "Make inodes per group a multiple of inodes per block"

diff --cc ext4_utils/make_ext4fs.c
index c9fd992,e37d617..22c9424
--- a/ext4_utils/make_ext4fs.c
+++ b/ext4_utils/make_ext4fs.c
@@@ -214,26 -215,10 +214,27 @@@ static u32 compute_inodes_per_group(
  {
  	u32 blocks = DIV_ROUND_UP(info.len, info.block_size);
  	u32 block_groups = DIV_ROUND_UP(blocks, info.blocks_per_group);
- 	return DIV_ROUND_UP(info.inodes, block_groups);
+ 	u32 inodes = DIV_ROUND_UP(info.inodes, block_groups);
+ 	return ALIGN(inodes, (info.block_size / info.inode_size));
  }
  
 +static u32 compute_bg_desc_reserve_blocks()
 +{
 +	u32 blocks = DIV_ROUND_UP(info.len, info.block_size);
 +	u32 block_groups = DIV_ROUND_UP(blocks, info.blocks_per_group);
 +	u32 bg_desc_blocks = DIV_ROUND_UP(block_groups * sizeof(struct ext2_group_desc),
 +			info.block_size);
 +
 +	u32 bg_desc_reserve_blocks =
 +			DIV_ROUND_UP(block_groups * 1024 * sizeof(struct ext2_group_desc),
 +					info.block_size) - bg_desc_blocks;
 +
 +	if (bg_desc_reserve_blocks > info.block_size / sizeof(u32))
 +		bg_desc_reserve_blocks = info.block_size / sizeof(u32);
 +
 +	return bg_desc_reserve_blocks;
 +}
 +
  void reset_ext4fs_info() {
      // Reset all the global data structures used by make_ext4fs so it
      // can be called again.
