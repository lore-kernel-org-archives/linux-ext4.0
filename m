From: Andreas Dilger <adilger@sun.com>
Subject: Re: [RFC]Ext4: journal credits reservation fixes for DIO,
	fallocate and delalloc writepages
Date: Wed, 23 Jul 2008 22:07:03 -0400
Message-ID: <20080724020703.GG5346@webber.adilger.int>
References: <48841077.500@cse.unsw.edu.au> <20080721082010.GC8788@skywalker>
 <1216774311.6505.4.camel@mingming-laptop> <20080723074226.GA15091@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Mingming Cao <cmm@us.ibm.com>, tytso <tytso@mit.edu>,
	Shehjar Tikoo <shehjart@cse.unsw.edu.au>,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:37991 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbYGXCHH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Jul 2008 22:07:07 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m6O276TA008206
	for <linux-ext4@vger.kernel.org>; Wed, 23 Jul 2008 19:07:06 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K4H00J01N548900@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 23 Jul 2008 19:07:06 -0700 (PDT)
In-reply-to: <20080723074226.GA15091@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 23, 2008  13:12 +0530, Aneesh Kumar wrote:
> On Tue, Jul 22, 2008 at 05:51:51PM -0700, Mingming Cao wrote:
> > @@ -1930,9 +1931,6 @@ int ext4_ext_calc_credits_for_insert(str
> >  	 */
> >  	needed += (depth * 2) + (depth * 2);
> > 
> > -	/* any allocation modifies superblock */
> > -	needed += 1;
> 
> Why are we dropping the super block modification credit ? An insert of
> an extent can result in super block modification also. If the goal is to
> use ext4_writepages_trans_blocks everywhere then this change is correct.
> But i see  many place not using ext4_writepages_trans_blocks.

We used to need to update the superblock on every allocation operation
(block or inode).  That was removed a long time ago, and we rarely
update the superblock these days.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

