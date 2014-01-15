From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: ext4: indirect block allocations not sequential in 3.4.67 and
 3.11.7
Date: Wed, 15 Jan 2014 12:22:14 -0800
Message-ID: <20140115202214.GH9229@birch.djwong.org>
References: <20140115192802.GK21295@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Benjamin LaHaise <bcrl@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:44455 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350AbaAOUWV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 15 Jan 2014 15:22:21 -0500
Content-Disposition: inline
In-Reply-To: <20140115192802.GK21295@kvack.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jan 15, 2014 at 02:28:02PM -0500, Benjamin LaHaise wrote:
> Hi folks,
> 
> As a follow on to my previous issue with ext3, it's looking like the 
> indirect block allocator in ext4 is not doing a very good job of making 
> block allocations sequential.  On a 1GB test filesystem, I'm getting 
> the following allocation results for 10MB files (written out with a single 
> 10MB write()):
> 
> debugfs:  stat testfile.0
> Inode: 12   Type: regular    Mode:  0600   Flags: 0x0   Generation: 2584871807
> User:     0   Group:     0   Size: 10485760
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 20512
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x52d6de73 -- Wed Jan 15 14:16:03 2014
> atime: 0x52d6de27 -- Wed Jan 15 14:14:47 2014
> mtime: 0x52d6de73 -- Wed Jan 15 14:16:03 2014
> BLOCKS:
> (0-11):24576-24587, (IND):8797, (12-1035):24588-25611, (DIND):8798, (IND):8799, 
> (1036-2059):25612-26635, (IND):10248, (2060-2559):26636-27135
> TOTAL: 2564

A dumpe2fs would be nice, but I think I have enough here to speculate:

The data blocks are all sequential, which looks like what one would expect from
mballoc.  Is your complaint is that the *IND blocks are not inline with the
data blocks, like what ext3 did?

FWIW, ext3 did something like this:
(0-11):6144-6155, (IND):6156, (12-1035):6157-7180, (DIND):7181, (IND):7182,
(1036-2059):7183-8206, (IND):8207, (2060-2559):8208-8707

I think the behavior that you're seeing is ext4 trying to keep the mapping
blocks close to the inode table to avoid fragmenting the file -- see
ext4_find_near() in indirect.c.  There's an XXX comment in ext4_find_goal()
that implies that someone might have wanted to tie in with mballoc, which I
suppose you could use to restore the ext3 behavior... but there's no way to do
that.

--D
> 
> debugfs:  stat testfile.1
> Inode: 15   Type: regular    Mode:  0600   Flags: 0x0   Generation: 1625569093
> User:     0   Group:     0   Size: 10485760
> File ACL: 0    Directory ACL: 0
> Links: 1   Blockcount: 20512
> Fragment:  Address: 0    Number: 0    Size: 0
> ctime: 0x52d6df0f -- Wed Jan 15 14:18:39 2014
> atime: 0x52d6df0f -- Wed Jan 15 14:18:39 2014
> mtime: 0x52d6df0f -- Wed Jan 15 14:18:39 2014
> BLOCKS:
> (0-11):12288-12299, (IND):8787, (12-1035):12300-13323, (DIND):8790, (IND):8791, 
> (1036-2059):13324-14347, (IND):8789, (2060-2559):14348-14847
> TOTAL: 2564
> 
> debugfs:
> 
> To give folks an idea about how significant an impact on performance this 
> is, using ext4 to mount my ext3 filesystem and create files is resulting 
> in a 10-15% reduction in speed when data is being read back into memory.  
> I also tested 3.11.7 and see the same poor allocation layout.  I also 
> tried turning off delalloc, but there was no change in the layout of the 
> data blocks.  Has anyone got any ideas what's going on here?  Cheers,
> 
> 		-ben
> -- 
> "Thought is the essence of where you are now."
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
