From: Andreas Dilger <adilger@sun.com>
Subject: Re: [PATCH] fiemap support for ext3
Date: Wed, 23 Apr 2008 20:56:30 -0600
Message-ID: <20080424025629.GL3095@webber.adilger.int>
References: <20080423193914.GA25173@unused.rdu.redhat.com>
 <20080423232725.GK3095@webber.adilger.int> <480FCAC9.8050105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Cc: Josef Bacik <jbacik@redhat.com>, linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:52006 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812AbYDXC4d (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Apr 2008 22:56:33 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id m3O2uWtR006411
	for <linux-ext4@vger.kernel.org>; Wed, 23 Apr 2008 19:56:32 -0700 (PDT)
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 id <0JZT005016P8LT00@fe-sfbay-09.sun.com> (original mail from adilger@sun.com)
 for linux-ext4@vger.kernel.org; Wed, 23 Apr 2008 19:56:32 -0700 (PDT)
In-reply-to: <480FCAC9.8050105@redhat.com>
Content-disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Apr 23, 2008  18:48 -0500, Eric Sandeen wrote:
> Andreas Dilger wrote:
> > On Apr 23, 2008  15:39 -0400, Josef Bacik wrote:
> >> +	/*
> >> +	 * we want the comparisons to be unsigned, in case somebody passes -1,
> >> +	 * meaning they want they want the entire file, but the result has to be
> >> +	 * signed so we can handle the case where we get more blocks than the
> >> +	 * size of the file
> >> +	 */
> >> +	length = (long)min((unsigned long)fiemap_s->fm_length,
> >> +			   (unsigned long)i_size_read(inode));
> > 
> > This might be written as:
> > 
> > 	length = (long)min_t(unsigned long,fiemap_s->fm_len,i_size_read(inode));
> > 
> > Also, what about files that have blocks mapped after i_size?
> 
> That'll be tough for ext3, though I guess for a generic interface it
> could happen, so I guess it needs to be handled.  

Right, because some filesystems may preallocate blocks beyond i_size to
avoid fragmentation.

> Maybe check i_blocks
> against i_size, see if i_blocks indicates blocks past EOF?  Hm, I guess
> that's not going to work in general; you could be completely sparse up
> to an EOF at 100G and have 100M of blocks past that...

...and there are also indirect blocks, and EA blocks that are not counted
toward i_size.  The issue is that getblock() doesn't have any way of
reporting that it is beyond EOF.  If it was an ext2/ext3-specific mechanism
then it could check in the i_block[] array and in the end of the
{t,d,}indirect blocks to know conclusively whether there are any blocks
beyond EOF.

That said, I don't think the generic interface can know everything about
each filesystem.  My suggestion was that blocks beyond i_size continue
to be mapped until a hole (block == 0) is returned.  It isn't perfect,
but would likely cover 99.9% of the cases where some small number of blocks
(<= 64kB or whatever) were allocated beyond EOF to avoid fragmentation.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

