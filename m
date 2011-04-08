From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 2/2] e2fsprogs: Add support for toggling, verifying,
	and fixing inode checksums
Date: Fri, 8 Apr 2011 12:25:30 -0700
Message-ID: <20110408192530.GE24354@tux1.beaverton.ibm.com>
References: <20110406224410.GB24354@tux1.beaverton.ibm.com> <20110406224733.GU32706@tux1.beaverton.ibm.com> <A63BE624-6F88-432C-A029-C7A0DF6C2894@dilger.ca>
Reply-To: djwong@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4 <linux-ext4@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:54950 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293Ab1DHTZj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Apr 2011 15:25:39 -0400
Content-Disposition: inline
In-Reply-To: <A63BE624-6F88-432C-A029-C7A0DF6C2894@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 08, 2011 at 03:14:04AM -0600, Andreas Dilger wrote:
> On 2011-04-06, at 4:47 PM, Darrick J. Wong wrote:
> > This patch adds to tune2fs the ability to toggle the inode checksum rocompat
> > feature flag, to e2fsck the ability to verify and correct inode checksums, and
> > to debugfs the ability to dump inode checksums.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > ---
> > @@ -729,6 +729,13 @@ void e2fsck_pass1(e2fsck_t ctx)
> > +		/* Check for invalid inode checksum */
> > +		if (!ext2fs_inode_csum_verify(fs, ino,
> > +			(struct ext2_inode_large *)inode) &&
> > +		    fix_problem(ctx, PR_1_INODE_CSUM_INVALID, &pctx))
> > +			e2fsck_write_inode_full(ctx, ino, inode,
> > +				sizeof(struct ext2_inode_large), "pass1");
> 
> If we just correct the checksum when it is found to be incorrect, then there
> is relatively little benefit in having it at all?  The default action in this
> case would likely be to declare the inode invalid and clears it, but there
> also needs to be a fallback option that declares the only checksum invalid
> and corrects it. 
> 
> Do you have an e2fsck testcase for this code, to show that it detects/fixes
> inodes with data corruption, and to fix the checksums after the ROCOMPAT flag
> is set the first time?

Not yet; I suspected that some clarification of exactly that issue was needed.
It looks to me that in general the checksum will be zero for the "flag is
enabled but no checksum has yet been provided" case, and nonzero in the "inode
is corrupt" case.  So if e2fsck sees zero it'd first ask to correct the
checksum, and if it sees nonzero it'll first ask to clear the inode.  If the
user answers no to the first question, e2fsck can then propose the second
option.

> With the "ibadness" patch in our tree, the bad checksum should be a
> significant factor in marking the inode as garbage, but possibly not enough
> to have it thrown out if there are no other errors in the inode.

Or e2fsck could use that heuristic; which tree is the ibadness patch in?
Google shows a patch from 2008, but no recent discussion.

Something along the lines of: if the inode is not very bad, ask first to fix
the checksum and second to clear the inode; if the inode seems bad, ask first
to clear it and second to fix the checksum.

> > @@ -890,6 +890,11 @@ static struct e2fsck_problem problem_table[] = {
> > 	     "(size %Is, lblk %r)\n"),
> > 	  PROMPT_CLEAR, PR_PREEN_OK },
> > 
> > +	/* Fast symlink has EXTENTS_FL set */
> > +	{ PR_1_INODE_CSUM_INVALID,
> > +	  N_("inode %i checksum invalid.  "),
> 
> The comment for each problem should exactly mirror the text that is printed.
> In this case, you haven't used the abbreviations "@i" and "@n", which would
> normally make it much harder to search for this error string in the code, but
> also simplifies the translation of the message.

Oops, comment blooper that was a thinko on my part.  What would the @n be for?

--D
