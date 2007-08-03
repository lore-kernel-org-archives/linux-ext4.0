From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH 3/4][e2fsprogs] Relax group descriptor checking.
Date: Fri, 3 Aug 2007 07:17:09 -0500
Message-ID: <20070803071709.11d0de76@gara>
References: <20070803040041.29456.31454.stgit@gara>
	<20070803040059.29456.55756.stgit@gara>
	<46B2BBF4.7010408@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:53607 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322AbXHCMTf (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 3 Aug 2007 08:19:35 -0400
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l73CJZTt008345
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 08:19:35 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.4) with ESMTP id l73CJZvL209408
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 06:19:35 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l73CJZ9t026890
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 06:19:35 -0600
Received: from austin.ibm.com (netmail2.austin.ibm.com [9.41.248.176])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id l73CJYhM026878
	for <linux-ext4@vger.kernel.org>; Fri, 3 Aug 2007 06:19:34 -0600
In-Reply-To: <46B2BBF4.7010408@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Fri, 03 Aug 2007 10:54:04 +0530
"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> Jose R. Santos wrote:
> > From: Jose R. Santos <jrs@us.ibm.com>
> > 
> >
> >  e2fsck/super.c          |   10 ++++++++--
> >  lib/ext2fs/check_desc.c |   10 ++++++++--
> >  2 files changed, 16 insertions(+), 4 deletions(-)
> > 
> > diff --git a/e2fsck/super.c b/e2fsck/super.c
> > index 00a131c..8e58e5c 100644
> > --- a/e2fsck/super.c
> > +++ b/e2fsck/super.c
> > @@ -578,8 +578,14 @@ void check_super_block(e2fsck_t ctx)
> >  	for (i = 0, gd=fs->group_desc; i < fs->group_desc_count; i++, gd++) {
> >  		pctx.group = i;
> > 
> > -		first_block = ext2fs_group_first_block(fs, i);
> > -		last_block = ext2fs_group_last_block(fs, i);
> > +		if (EXT2_HAS_INCOMPAT_FEATURE (fs->super,
> > +			EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
> > +			first_block = fs->super->s_first_data_block;
> > +			last_block = fs->super->s_blocks_count;
> 
> 
> I guess this should be fs->super->s_blocks_count - 1 ;

Updated.

> > +		} else {
> > +			first_block = ext2fs_group_first_block(fs, i);
> > +			last_block = ext2fs_group_last_block(fs, i);
> > +		}
> > 
> >  		if ((gd->bg_block_bitmap < first_block) ||
> >  		    (gd->bg_block_bitmap > last_block)) {
> > diff --git a/lib/ext2fs/check_desc.c b/lib/ext2fs/check_desc.c
> > index 146f9e5..bb65c06 100644
> > --- a/lib/ext2fs/check_desc.c
> > +++ b/lib/ext2fs/check_desc.c
> > @@ -38,8 +38,14 @@ errcode_t ext2fs_check_desc(ext2_filsys fs)
> >  	EXT2_CHECK_MAGIC(fs, EXT2_ET_MAGIC_EXT2FS_FILSYS);
> > 
> >  	for (i = 0; i < fs->group_desc_count; i++) {
> > -		first_block = ext2fs_group_first_block(fs, i);
> > -		last_block = ext2fs_group_last_block(fs, i);
> > +		if (EXT2_HAS_INCOMPAT_FEATURE (fs->super, EXT4_FEATURE_INCOMPAT_FLEX_BG)) {
> > +			first_block = fs->super->s_first_data_block;
> > +			last_block = fs->super->s_blocks_count;
> > +		
> 
> I guess this should be fs->super->s_blocks_count - 1 ;

Updated.

Thanks
 
> -aneesh

-JRS
