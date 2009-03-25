From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: [RFC][PATCH 0/3] ext4: online defrag (ver 1.0)
Date: Wed, 25 Mar 2009 04:53:05 -0700 (PDT)
Message-ID: <22700089.post@talk.nabble.com>
References: <49829A1D.5090002@rs.jp.nec.com> <87f94c370901301433x3e22892n5fddbb0804bddc4@mail.gmail.com> <49894CD4.4060000@rs.jp.nec.com> <20090204140911.GB14762@mit.edu> <87f94c370902040651v388db0aak46d7843872d312ce@mail.gmail.com> <20090204153205.GF14762@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from kuber.nabble.com ([216.139.236.158]:37585 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760788AbZCYLxH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 25 Mar 2009 07:53:07 -0400
Received: from isper.nabble.com ([192.168.236.156])
	by kuber.nabble.com with esmtp (Exim 4.63)
	(envelope-from <lists@nabble.com>)
	id 1LmRfN-0000nA-Mq
	for linux-ext4@vger.kernel.org; Wed, 25 Mar 2009 04:53:05 -0700
In-Reply-To: <20090204153205.GF14762@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>



Theodore Ts'o-2 wrote:
> 
> On Wed, Feb 04, 2009 at 09:51:07AM -0500, Greg Freemyer wrote:
>  
> If the OHSM team implements a similar ioctl for ext2 and ext3 and
> submits them for mainline at some point, do they have a chance of
> being accepted or are ext2 and ext3 feature frozen?
> 
> It seems unlikely it would be accepted.  If the patch could be done in
> a way that seriously minimized the chances of destablizing the code,
> maybe --- but consider also that the OHSM design is a pretty terrible
> hack.  I'm not at all conviced they will be able to stablize it for
> 

I could not understand what makes you feel like that. The idea of OHSM is 
simply to exploit the underlying device topology on which the file system
resides and
have a better block allocation policy based on that. Just a kind of
handshake 
between the Filesystem and the logical volume.

Can you be a bit more specific on what makes you feel that its not the right 
way to achieve such goals?


> production use, and a scheme that involves using dmapi across multiple
> block devices.
> 

Well, we already have stable ioctls through dmapi which provides the
underlying topology of the logical device.
Which I believe is pretty stable at this point in time.



> Note that they apparently need to make other changes to the core
> filesystem code besides just the ioctl --- to the block allocation
> code, at the very least.
> 

Agreed. There would be considerable changes revolving around the block
allocation.
But, the major change would be revolving around the block allocation ONLY.
And the motivation 
for OHSM to think in the direction of ext4 was the mail from Akira which
mentions that we are in 
plan for a similar ioctl based interface for ext4. 
Just to quote: 
"(2) An (ioctl-based) interface which associates with an inode
preferred range(s) of blocks which the block allocator will try using
first; if those blocks are not available, or the block range(s) is
exhausted, the block allocator use its normal algorithms to pick the
best available block.  The set of preferred blocks is only guaranteed
to persist while the inode is in memory.".

http://patchwork.ozlabs.org/patch/12877/

Other than these most of the other implementation resides in a separate
module.

Don't you think that atleast we are clean at block allocation and dmapi.
The major concerns that you had.



> The right answer is really to use a stackable filesystem, and to use
> separate filesystems for each different tier, and then build on top of
> unionfs to give it its policy support.  I suspect that OHSM will be a
> cute student project, but it won't become anything serious given its
> architecture/design, unfortunately.
> 

This can be one of the possible ways of achieving it and may be a better
one. 

Regards,
Sandeep.



> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



-- 
View this message in context: http://www.nabble.com/-RFC--PATCH-0-3--ext4%3A-online-defrag-%28ver-1.0%29-tp21742025p22700089.html
Sent from the linux-ext4 mailing list archive at Nabble.com.

