From: Mingming Cao <cmm@us.ibm.com>
Subject: Re: [PATCH 1/5] ext4 online defrag header file changes
Date: Fri, 28 Mar 2008 17:49:43 -0700
Message-ID: <1206751783.3629.17.camel@localhost.localdomain>
References: <200803241231.AA00344@TNESG9526.rs.jp.nec.com>
	 <20080325174827.GA7190@skywalker>  <47EB73DE.7050702@rs.jp.nec.com>
Reply-To: cmm@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Andreas Dilger <adilger@sun.com>, tytso@mit.edu,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:54236 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755070AbYC2Atq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 28 Mar 2008 20:49:46 -0400
In-Reply-To: <47EB73DE.7050702@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, 2008-03-27 at 19:15 +0900, Akira Fujita wrote:
> Aneesh Kumar K.V wrote:
> > On Mon, Mar 24, 2008 at 09:31:03PM +0900, Akira Fujita wrote:
> >   
> >> Hi Aneesh,
> >>     
> >>> On Mon, Mar 24, 2008 at 08:00:54PM +0900, Akira Fujita wrote:
> >>>       
> >>>>>   
> >>>>>           
> >>>> Is EXT4_IOC_FIEMAP going to be added to the ext4 patch queue?
> >>>> I will try to use EXT4_IOC_FIEMAP instead of EXT4_IOC_EXTENTS_INFO
> >>>> in ext4 online defrag when kernel supports it.
> >>>>         
> >>> Can you also look at the sparse warnings with the patches ?
> >>>
> >>>       
> >> I have already released the fixed patch before, but it is not in the ext4 patch queue yet.
> >> Mingming, could you replace new ext4-online-defrag-free-space-fragmentation.patch
> >> with old one in the ext4 patch queue? 
> >>
> >>     
> >
> >   CHECK   fs/ext4/defrag.c
> >   fs/ext4/defrag.c:181:7: warning: cast to restricted type
> >   fs/ext4/defrag.c:181:7: warning: cast from restricted type
> >   fs/ext4/defrag.c:613:21: warning: incorrect type in argument 1
> >   (different address spaces)
> >   fs/ext4/defrag.c:613:21:    expected void [noderef] <asn:1>*to
> >   fs/ext4/defrag.c:613:21:    got struct ext4_group_data_info *<noident>
> >   fs/ext4/defrag.c:629:24: warning: incorrect type in argument 1
> >   (different address spaces)
> >   fs/ext4/defrag.c:629:24:    expected void [noderef] <asn:1>*to
> >   fs/ext4/defrag.c:629:24:    got struct ext4_extents_info *<noident>
> >   fs/ext4/defrag.c:849:29: warning: potentially expensive pointer
> >   subtraction
> >   fs/ext4/defrag.c:912:22: warning: potentially expensive pointer
> >   subtraction
> >
> > you would need http://www.kernel.org/pub/software/devel/sparse/
> > to find and fix these warnings.
> >
> >   
> Oops, there are a lot of warnings. =-O
> Thank you for letting me know.
> I will release fixed defrag patches in a few days.

As part of transition to move ext4 related header files out of
include/linux, and move to fs/ext4, I also updated the defrag patches to
adapt this change. You might want to checkout the defrag patches in
patch queue and merge the updates before release the new version.

Cheers,
Mingming


