From: Andreas Dilger <adilger.kernel@dilger.ca>
Subject: Re: [PATCH 2/2] e2fsprogs: Add support for toggling, verifying, and fixing inode checksums
Date: Fri, 8 Apr 2011 17:13:13 -0600
Message-ID: <001599E2-27BF-48AF-BC4E-DE8B674FF46B@dilger.ca>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com> <20110406224733.GU32706@tux1.beaverton.ibm.com> <A63BE624-6F88-432C-A029-C7A0DF6C2894@dilger.ca> <20110408192530.GE24354@tux1.beaverton.ibm.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Ts'o <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: djwong@us.ibm.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:27600 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398Ab1DHXNR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2011 19:13:17 -0400
In-Reply-To: <20110408192530.GE24354@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-04-08, at 1:25 PM, Darrick J. Wong wrote:
> On Fri, Apr 08, 2011 at 03:14:04AM -0600, Andreas Dilger wrote:
>> Do you have an e2fsck testcase for this code, to show that it detects/fixes
>> inodes with data corruption, and to fix the checksums after the ROCOMPAT flag
>> is set the first time?
> 
> Not yet; I suspected that some clarification of exactly that issue was needed.
> It looks to me that in general the checksum will be zero for the "flag is
> enabled but no checksum has yet been provided" case, and nonzero in the "inode
> is corrupt" case.  So if e2fsck sees zero it'd first ask to correct the
> checksum, and if it sees nonzero it'll first ask to clear the inode.  If the
> user answers no to the first question, e2fsck can then propose the second
> option.

Seems reasonable, though it is possible that the inode checksums can also become invalid due to changing the filesystem UUID.  This should probably be handled by tune2fs when the UUID is changed, with an extra prompt if INODE_CSUM is enabled to indicate that the conversion may take a long time.

Looking at the checksum algorithm you used, the inode checksum does not change if the inode is relocated due to resize (i.e. it uses the inode number and not the underlying block number).  This is convenient, and does not impact the correctness in any way - if the wrong block is read/written then the inode number used in the checksum will not match either.

>> With the "ibadness" patch in our tree, the bad checksum should be a
>> significant factor in marking the inode as garbage, but possibly not enough
>> to have it thrown out if there are no other errors in the inode.
> 
> Or e2fsck could use that heuristic; which tree is the ibadness patch in?
> Google shows a patch from 2008, but no recent discussion.

There is a relatively up-to-date version at
http://git.whamcloud.com/?p=tools/e2fsprogs.git;a=blob_plain;f=patches/e2fsprogs-ibadness-counter.patch;hb=8dd11ed9bdf0914d57d78d0c387bd21f747c1d29

> Something along the lines of: if the inode is not very bad, ask first to fix
> the checksum and second to clear the inode; if the inode seems bad, ask first
> to clear it and second to fix the checksum.

Yes, that is what I was thinking.  The real question is why the checksum would be bad in the case of no other "badness"?  If it is due to the UUID, that should be handled when the UUID is changed, and if it is due to a misplaced write (i.e. bad inode number) then it will help us to distinguish between the "real" inode and the misplaced "bad" inode.

>>> @@ -890,6 +890,11 @@ static struct e2fsck_problem problem_table[] = {
>>> 	     "(size %Is, lblk %r)\n"),
>>> 	  PROMPT_CLEAR, PR_PREEN_OK },
>>> 
>>> +	/* Fast symlink has EXTENTS_FL set */
>>> +	{ PR_1_INODE_CSUM_INVALID,
>>> +	  N_("inode %i checksum invalid.  "),
>> 
>> The comment for each problem should exactly mirror the text that is printed.
>> In this case, you haven't used the abbreviations "@i" and "@n", which would
>> normally make it much harder to search for this error string in the code, but
>> also simplifies the translation of the message.
> 
> Oops, comment blooper that was a thinko on my part.  What would the @n be for?

@i is "inode", @n is "invalid", per e2fsck/message.c.

Cheers, Andreas





