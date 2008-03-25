From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/5] ext4 online defrag header file changes
Date: Tue, 25 Mar 2008 23:18:27 +0530
Message-ID: <20080325174827.GA7190@skywalker>
References: <200803241231.AA00344@TNESG9526.rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, cmm@us.ibm.com, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:56977 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbYCYRsm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 25 Mar 2008 13:48:42 -0400
Content-Disposition: inline
In-Reply-To: <200803241231.AA00344@TNESG9526.rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 24, 2008 at 09:31:03PM +0900, Akira Fujita wrote:
> Hi Aneesh,
> > On Mon, Mar 24, 2008 at 08:00:54PM +0900, Akira Fujita wrote:
> >>>   
> >> Is EXT4_IOC_FIEMAP going to be added to the ext4 patch queue?
> >> I will try to use EXT4_IOC_FIEMAP instead of EXT4_IOC_EXTENTS_INFO
> >> in ext4 online defrag when kernel supports it.
> >
> > Can you also look at the sparse warnings with the patches ?
> >
> I have already released the fixed patch before, but it is not in the ext4 patch queue yet.
> Mingming, could you replace new ext4-online-defrag-free-space-fragmentation.patch
> with old one in the ext4 patch queue? 
> 

  CHECK   fs/ext4/defrag.c
  fs/ext4/defrag.c:181:7: warning: cast to restricted type
  fs/ext4/defrag.c:181:7: warning: cast from restricted type
  fs/ext4/defrag.c:613:21: warning: incorrect type in argument 1
  (different address spaces)
  fs/ext4/defrag.c:613:21:    expected void [noderef] <asn:1>*to
  fs/ext4/defrag.c:613:21:    got struct ext4_group_data_info *<noident>
  fs/ext4/defrag.c:629:24: warning: incorrect type in argument 1
  (different address spaces)
  fs/ext4/defrag.c:629:24:    expected void [noderef] <asn:1>*to
  fs/ext4/defrag.c:629:24:    got struct ext4_extents_info *<noident>
  fs/ext4/defrag.c:849:29: warning: potentially expensive pointer
  subtraction
  fs/ext4/defrag.c:912:22: warning: potentially expensive pointer
  subtraction

you would need http://www.kernel.org/pub/software/devel/sparse/
to find and fix these warnings.

-aneesh
