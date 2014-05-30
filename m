From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC][PATCH] ext4: handle fast symlink properly with inline_data
Date: Fri, 30 May 2014 16:26:33 -0700
Message-ID: <20140530232633.GE17413@birch.djwong.org>
References: <1392275237-6998-1-git-send-email-wenqing.lz@taobao.com>
 <20140218015231.GF26580@thunk.org>
 <292627A0-B8C3-4B49-9795-E5DA18462A4B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Zheng Liu <gnehzuil.liu@gmail.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Ian Nartowicz <claws@nartowicz.co.uk>, Tao Ma <tm@tao.ma>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Zheng Liu <wenqing.lz@taobao.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46052 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaE3X0w (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 30 May 2014 19:26:52 -0400
Content-Disposition: inline
In-Reply-To: <292627A0-B8C3-4B49-9795-E5DA18462A4B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Feb 18, 2014 at 11:07:24AM -0800, Andreas Dilger wrote:
> I suspect that the stats for symlinks > 60 but < ~150 chars is only a very
> small fraction of files. If the code complexity of handling this is very
> small (i.e. it is just handled as a natural consequence of writing "data" 
> of this size) then I would be OK with it. 
> 
> Otherwise, I expect the code and maintenance overhead of supporting
> the 0.01% (?) of symlinks that are this size is probably lot worth it. 
> 
> People could check what the actual usage is via the "fsstats" tool at:
> 
> http://www.pdsi-scidac.org/fsstats/
> 
> There is also data there already that reports stats on symlink length, but
> it is mostly HPC filesystems and it might be better to redo this with a
> desktop-type workload. 

I think we should either put in this kernel patch so that we can read inline
data fast symlinks, or remove the ability to write inline data fast symlinks.
It's a bit surprising that I can do:

# mke2fs -t ext4 -O inline_data /dev/sdb         
# mount /dev/sdb /mnt/
# ln -s "Fuzzy Wuzzy was a bear. Fuzzy Wuzzy had no hair. I guess he wasn't fuzzy, was he?" /mnt/biglink
# readlink /mnt/biglink
Fuzzy Wuzzy was a bear. Fuzzy Wuzzy had no hair. I guess he wasn't fuzzy, was he?
# umount /mnt
# mount /dev/sdb /mnt/
# readlink /mnt/biglink
Fuzzy Wuzzy was a bear. Fuzzy Wuzzy had no hair. I guess he

What happened to the punchline of the limerick? ------------^^^^^^^ ???? :)

e2fsck still seems to think that you can't have inline_data fast symlinks.  I
don't see a downside to continuing to allow them.

--D

> 
> Cheers, Andreas
> 
> >> On Feb 17, 2014, at 17:52, Theodore Ts'o <tytso@mit.edu> wrote:
> >> 
> >> On Thu, Feb 13, 2014 at 03:07:17PM +0800, Zheng Liu wrote:
> >> 
> >> I am not sure whether or not we need to enable inline_data for a fast
> >> symlink inode.  Obviously, it brings a benefit that after enabling
> >> inline_data feature for a fast symlink we can get more space to store
> >> the path.  But it seems that the original patch doesn't want to do this
> >> Another solution for fixing this bug is to disable inline_data for a
> >> fast symlink.  Any comment?
> > 
> > Well, if we are using inline data, and we have a symlink which is
> > longer than 60 bytes, but less than extra space available for an
> > inline data, it seems like a good thing to support.
> > 
> > The downside is that it is a bit more complication to add the kernel's
> > code in both the kernel as well as e2fsprogs, but it doesn't seem that
> > bad.
> > 
> > So I don't have any objections to adding this functionality.  What do
> > other folks think?
> > 
> >                       - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
