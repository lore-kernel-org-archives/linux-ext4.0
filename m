From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RFC] ext4: collapse a single extent tree block into the
 inode if possible
Date: Thu, 9 Aug 2012 08:56:13 -0400
Message-ID: <20120809125613.GA4511@thunk.org>
References: <1344516283-4430-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Ext4 Developers List <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:43799 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932262Ab2HIM4Q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 9 Aug 2012 08:56:16 -0400
Content-Disposition: inline
In-Reply-To: <1344516283-4430-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Aug 09, 2012 at 08:44:43AM -0400, Theodore Ts'o wrote:
> If an inode has more than 4 extents, but then later some of the
> extents are merged together, we can optimize the file system by moving
> the extents up into the inode, and discarding extent tree block.  This
> is important, because if there are a large number of inodes with an
> external extent tree blocks where the contents could fit in the inode,
> this can significantly increase the fsck time of the file system.

This version of the patch has an ext4_msg() which I will remove in the
final version of the patch, but it's interesting because it shows how
much the code path is being exercised.

We see that for fsstress, we do definitely exercise the code path,
which is good --- and it does mean that we end up with a more
efficient extent tree structure:

013	[  150.077567] EXT4-fs (vdb): Merge up: ino 145516, blk 646045, extents 4
[  166.027004] EXT4-fs (vdb): Merge up: ino 145666, blk 646800, extents 4
[  169.071057] EXT4-fs (vdb): Merge up: ino 145549, blk 646604, extents 3
[  173.454559] EXT4-fs (vdb): Merge up: ino 145525, blk 646319, extents 2
[  175.192647] EXT4-fs (vdb): Merge up: ino 145872, blk 650733, extents 3
[  181.479258] EXT4-fs (vdb): Merge up: ino 145542, blk 642934, extents 3
[  186.981250] EXT4-fs (vdb): Merge up: ino 145531, blk 647727, extents 3
[  189.322060] EXT4-fs (vdb): Merge up: ino 146380, blk 650804, extents 3
[  191.733159] EXT4-fs (vdb): Merge up: ino 145511, blk 646831, extents 4
[  192.160757] EXT4-fs (vdb): Merge up: ino 145576, blk 647309, extents 4
[  193.496868] EXT4-fs (vdb): Merge up: ino 145607, blk 648214, extents 3
[  201.062707] EXT4-fs (vdb): Merge up: ino 145505, blk 642449, extents 3
[  207.962396] EXT4-fs (vdb): Merge up: ino 145575, blk 650461, extents 4
[  212.571402] EXT4-fs (vdb): Merge up: ino 146332, blk 651223, extents 3
[  221.973210] EXT4-fs (vdb): Merge up: ino 146109, blk 651455, extents 4
[  223.294616] EXT4-fs (vdb): Merge up: ino 146171, blk 650612, extents 3
[  239.745663] EXT4-fs (vdb): Merge up: ino 146109, blk 651138, extents 3
[  241.460200] EXT4-fs (vdb): Merge up: ino 145569, blk 646818, extents 4
 160s

However, then there are workloads such as fsx where the results of
this patch are not so good:

091	[  650.736485] EXT4-fs (vdb): Merge up: ino 14, blk 61095, extents 3
[  650.743739] EXT4-fs (vdb): Merge up: ino 14, blk 62879, extents 3
[  650.786122] EXT4-fs (vdb): Merge up: ino 14, blk 62929, extents 3
[  650.804720] EXT4-fs (vdb): Merge up: ino 14, blk 62282, extents 4
[  650.808706] EXT4-fs (vdb): Merge up: ino 14, blk 62283, extents 3
[  651.207374] EXT4-fs (vdb): Merge up: ino 14, blk 62502, extents 2
[  651.213186] EXT4-fs (vdb): Merge up: ino 14, blk 62503, extents 4
[  651.232026] EXT4-fs (vdb): Merge up: ino 14, blk 62938, extents 2
[  651.251615] EXT4-fs (vdb): Merge up: ino 14, blk 62951, extents 4
[  651.548798] EXT4-fs (vdb): Merge up: ino 14, blk 64947, extents 4
[  651.577057] EXT4-fs (vdb): Merge up: ino 14, blk 62662, extents 3
[  651.596868] EXT4-fs (vdb): Merge up: ino 14, blk 62663, extents 4
[  651.884237] EXT4-fs (vdb): Merge up: ino 14, blk 62930, extents 4
[  651.889220] EXT4-fs (vdb): Merge up: ino 14, blk 62931, extents 4
[  651.929939] EXT4-fs (vdb): Merge up: ino 14, blk 62936, extents 3
[  651.955671] EXT4-fs (vdb): Merge up: ino 14, blk 62937, extents 4
[  651.960726] EXT4-fs (vdb): Merge up: ino 14, blk 65502, extents 4
     ...  [ 960 additional, similar lines elided for brevity's sake ]

Granted, fsx is an extreme test program which is not likely to be
representative of real-life workloads.  However, it is fair to note
that the merge up code does have a cost, since it's possible that we
could repeatedly allocate and deallocate the external extent tree
block.

I'm not sure I care, but I'd appreciate any other thoughts people
might have on the subject.  Can anyone think of a real-life scenario
where this might be an issue?

Thanks,

						- Ted
