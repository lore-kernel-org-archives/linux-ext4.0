From: "Jose R. Santos" <jrs@us.ibm.com>
Subject: Re: [PATCH 4/4][e2fsprogs] New bitmap and inode table allocation
 for FLEX_BG
Date: Mon, 5 Nov 2007 09:09:46 -0600
Message-ID: <20071105090946.7668a20e@gara>
References: <20070814043245.32206.34785.stgit@gara>
	<20070814043314.32206.28698.stgit@gara>
	<20071104005208.GA6455@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.146]:57592 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753679AbXKEPHG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 5 Nov 2007 10:07:06 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e6.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id lA5F8d8D006184
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 10:08:39 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id lA5F73b3123748
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 10:07:03 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id lA5F727v029769
	for <linux-ext4@vger.kernel.org>; Mon, 5 Nov 2007 10:07:03 -0500
In-Reply-To: <20071104005208.GA6455@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sat, 3 Nov 2007 20:52:08 -0400
Theodore Tso <tytso@mit.edu> wrote:

> On Mon, Aug 13, 2007 at 11:33:14PM -0500, Jose R. Santos wrote:
> > +	if (EXT2_HAS_INCOMPAT_FEATURE (fs->super, 
> > +				       EXT4_FEATURE_INCOMPAT_FLEX_BG)) 
> > +		ext2fs_allocate_flex_groups(fs);
> > +	
> > +	else {
> > +		for (i = 0; i < fs->group_desc_count; i++) {
> > +			retval = ext2fs_allocate_group_table(fs, i, fs->block_map);
> > +			if (retval)
> > +				return retval;
> > +		}
> 
> The code to handle flex groups needs to be moved into
> ext2fs_allocate_group_table(), and not put in
> ext2fs_allocate_tables(), since resize2fs calls
> ext2fs_allocate_group_table(), and we want resize2fs to do the right
> thing for filesystems that have both the FLEX_BG and META_BG flags
> set.  Speaking of which, we need to fix the kernel on-line resizing
> code to allocate new blocks for filesystem metadata blocks using the
> new placement algorithm for FLEX_BG && META_BG filesystems.
> 
> I'll fix this up for the 'pu' branch of e2fsprogs, as well as making
> ext2fs_allocate_flex_groups static, but I'm not going to graduate this
> to the 'next' branch just yet, since it needs a bit more testing,
> specifically with resize2fs.

Yes, this code is not ready for 'next' branch.  This was mostly
intended as RFC and testing.  Resizing is not handle at all in this
code and fsck needs more testing.

> 						- Ted



-JRS
