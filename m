From: Theodore Tso <tytso@mit.edu>
Subject: Re: Possible ext4 corruption - ACL related?
Date: Thu, 12 Mar 2009 20:55:06 -0400
Message-ID: <20090313005506.GN17104@mit.edu>
References: <20090310070915.GN3199@webber.adilger.int> <20090310144651.GC23075@mit.edu> <1236719691.16191.9.camel@kulgan.wumi.org.au> <20090310224810.GA15229@mit.edu> <20090311003845.GB3199@webber.adilger.int> <1236735808.16191.23.camel@kulgan.wumi.org.au> <1236736137.16191.25.camel@kulgan.wumi.org.au> <20090311061839.GC3199@webber.adilger.int> <20090311132556.GB13698@mit.edu> <1236794830.6624.11.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Kevin Shanahan <kmshanah@ucwb.org.au>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:50936 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbZCMAz3 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 12 Mar 2009 20:55:29 -0400
Content-Disposition: inline
In-Reply-To: <1236794830.6624.11.camel@kulgan.wumi.org.au>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Mar 12, 2009 at 04:37:10AM +1030, Kevin Shanahan wrote:
> But getfattr isn't going to cause a read from the pipe is it? I would
> expect that to cause a read from the disk. 

Ah, yes, the getfattr would have caused a read from disk.  I missed
that the I/O error could have been caused by that.

Still, e2fsck should have cleared the acl block if it was illegal the
last time that you ran a full fsck on the filesystem.

> Inode	Pathname
> 864	/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/Cdo32pl.dll
> 875	/local/apps/Gestalt.Net/SetupCD/program files/Business Objects/Common/3.5/bin/RptControllers.dll

Well, it's likely those files are corrupted, so you might as well
delete them and restore from backup if needed/appropriate/possible.

> > One of the original inodes involved was 867, right?  You might want to
> > try using the "stat <867>" command and seeing if it still contains
> > garbage or not.  Since that was e2fsck should have deleted for you (or
> > did you delete it manually yourself?), it should either be all zero's,
> > or it should contain the same inode garbage you had sent to the list,
> > but with an i_links_count of zero if you deleting the file via the
> > "rm" command.  If it contains a different version of garbage, then
> > something is corrupting that block, possibly on the read path or the
> > write path.
> 
> debugfs:  stat <867>
> 
> Inode: 867   Type: bad type    Mode:  0404   Flags: 0x0
> Generation: 2483046020    Version: 0x17a7fdfd
> User: 1455931783   Group: -798021131   Size: 0
> File ACL: 0    Directory ACL: 0
> Links: 0   Blockcount: 0
> Fragment:  Address: 956780679    Number: 0    Size: 0
> ctime: 0xdca60244 -- Wed Apr 23 01:54:36 2087
> atime: 0x5c9e956c -- Sat Mar 30 08:30:12 2019
> mtime: 0x2ce44e11 -- Sat Nov 13 13:31:37 1993
> dtime: 0x49b6564f -- Tue Mar 10 22:30:15 2009
> Size of extra inode fields: 4
> BLOCKS:
> (0):1487030929, (1):3739364871, (2):16299385, (3):2955804704,
> (4):3028301176, (5):3255403360, (6):4066441585, (7):643698920,
> (8):377498450, (9):297332775, (10):2206476866, (11):169813600,
> (IND):2885921245, (DIND):1077961371, (TIND):3308808842
> TOTAL: 15
> 
> Looks like fsck cleaned up a number of the fields, but not all zeroed.
> It seems to have gained some blocks too, but I guess that is meaningless
> for an unlinked inode?

It's meaningless for an unlinked inode, but it still shouldn't have
happened.  I'm not sure how it could have happened in the first place.   

Hmmm, I really don't know what to tell you; at this point probably the
best thing to do is to delete the last inodes used in that inode
table block, and then keep a watchful eye on the filesystem.

      	     	      	     	      	     - Ted
