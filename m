From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC]Ext4: journal credits reservation fixes for DIO,
	fallocate and delalloc writepages
Date: Tue, 22 Jul 2008 19:18:02 -0600
Message-ID: <20080723011802.GB20749@webber.adilger.int>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
 <1216774311.6505.4.camel@mingming-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: linux-ext4@vger.kernel.org,
	Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	"Theodore Ts'o" <tytso@mit.edu>
To: Mingming Cao <cmm@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:63367 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbYGWBSG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 22 Jul 2008 21:18:06 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6N1I4s0011527
	for <linux-ext4@vger.kernel.org>; Tue, 22 Jul 2008 18:18:04 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4F00A01Q6UDB00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Tue, 22 Jul 2008 18:18:04 -0700 (PDT)
In-reply-to: <1216774311.6505.4.camel@mingming-laptop>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 22, 2008  17:51 -0700, Mingming Cao wrote:
> + * Calulate the total number of credits to reserve to fit
> + * the modification of @num pages into a single transaction
> + */
> +int ext4_writepages_trans_blocks(struct inode *inode, int num)
> +{
> +	int bpp = ext4_journal_blocks_per_page(inode);
> +	int nrblocks = num * bpp;
> +
> +	if (!EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL)
> +		return ext4_writepages_trans_blocks_old(inode, nrblocks);

This should be "if (!(EXT4_I(inode)->i_flags & EXT_EXTENTS_FL))", and
we should probably make it "unlikely()" since we expect most new files
in an ext4 filesystem are extent mapped.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

