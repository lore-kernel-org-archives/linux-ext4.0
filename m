From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH -v2] ext4: Use inode preallocation with -o noextents
Date: Thu, 05 Jun 2008 14:58:30 -0600
Message-ID: <20080605205830.GE2961@webber.adilger.int>
References: <1211229262-11012-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20080604022356.GA7094@mit.edu> <20080604040101.GA22348@skywalker>
 <20080605032220.GC10488@mit.edu> <20080605084329.GB8942@skywalker>
 <20080605153701.GB25477@mit.edu> <20080605182830.GW2961@webber.adilger.int>
 <20080605191251.GC4723@skywalker>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, cmm@us.ibm.com, sandeen@redhat.com,
	linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:51798 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbYFEU6l (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 5 Jun 2008 16:58:41 -0400
Received: from fe-sfbay-10.sun.com ([192.18.43.129])
	by sca-es-mail-2.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m55Kwemu025913
	for <linux-ext4@vger.kernel.org>; Thu, 5 Jun 2008 13:58:40 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-10.sun.com by fe-sfbay-10.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0K2000501CM77D00@fe-sfbay-10.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Thu, 05 Jun 2008 13:58:40 -0700 (PDT)
In-reply-to: <20080605191251.GC4723@skywalker>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jun 06, 2008  00:42 +0530, Aneesh Kumar K.V wrote:
> On Thu, Jun 05, 2008 at 12:28:30PM -0600, Andreas Dilger wrote:
> > I don't necessarily agree that meta should be implied by inode != NULL.
> > We do want to cluster metadata allocations for a single inode if possible,
> > so keeping the inode information is useful.  We may want to keep a separate
> > "metadata goal block" from the "data goal block" in the inode...
> > 
> > That said, it seems you still have a "meta" parameter here?  I always hate
> > having an int for a boolean, and we may as well make this a "flags" so
> > that when we want to improve it later we don't need to rename it and change
> > all of the "1" parameters to "EXT4_META_BLOCK".  Do it right the first time.
> > 
> 
> how about ?
> 
> +#defin EXT4_META_BLOCK 0x1

> @@ -1950,7 +1952,7 @@ static ext4_fsblk_t do_blk_alloc(handle_t *handle, struct inode *inode,
> -       if (S_ISREG(inode->i_mode) && !meta)
> +       if (S_ISREG(inode->i_mode) && !(flags & EXT4_META_BLOCK))

I'm fine with this.

> +       return do_blk_alloc(handle, inode, 0, goal, &count,
> +                                               errp, EXT4_META_BLOCK);

Please follow the normal CodingStyle.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

