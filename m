From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Patch 9/13] Adds two extended options and config file counterparts.
Date: Tue, 24 Jul 2007 12:32:54 -0400
Message-ID: <20070724163254.GE11826@thunk.org>
References: <1185275104.3789.74.camel@dhcp4.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Girish Shilamkar <girish@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:52296 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbXGXQc6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jul 2007 12:32:58 -0400
Content-Disposition: inline
In-Reply-To: <1185275104.3789.74.camel@dhcp4.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 24, 2007 at 04:35:04PM +0530, Girish Shilamkar wrote:
> This patch adds two extended options and config file counterparts.
> On the command line:
> 
>   -E shared=preserve|lost+found|delete
> 
>      Select the disposition of files containing shared blocks.  "preserve"
>      is the old behavior which remains the default.  "lost+found" causes
>      files to be unlinked after cloning so they will be reconnected to
>      /lost+found in pass 3.   "delete" skips cloning entirely and simply
>      deletes the files.

Jim Garlick and I discussed this back in April, and I pointed out a
flaw in his patch.  It doesn't correctly handle the case where the
system administrator wishes to move an inode that contains blocks
claimed by other inodes to lost+found, since it only unlinks the first
filename of the inode.  The result is that the inode loses one of its
directory entries, but it doesn't get oved to lost+found.

Jim reworked the patch to solve this issue, by keeping a linked list
of all of the directory entries where a particular inode could be
found.  This increases the memory used and increases the time to do
pass 1C, though.  The patch you have in your patch queue is the
original version of the patch, not his updated one.

I'm still not happy with this approach, though, since it adds extra
complexity and special case handling into e2fsprogs.  I had made a
counter-proposal as a better long-term approach, which Jim seemed to
agree would meet his needs:

>One of my long-term plans was to extend the fix_problem() function to
>log a detailed set of problems fixed into a file (either binary or
>XML) that could parsed by other programs as part of some kind of
>recovery process.  What would get written out is the problem ID plus
>the entire problem_context structure, which has actually quite a lot
>of information.  This would be enough for a lot of post-processing,
>including making it easier for people to implement policies such as
>deleted or archiving for review by the Site Security Officer any files
>which had some of their blocks cloned.

						- Ted
