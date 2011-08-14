From: Ted Ts'o <tytso@mit.edu>
Subject: Re: xfstests #62 broken on ext4
Date: Sat, 13 Aug 2011 20:44:17 -0400
Message-ID: <20110814004417.GA3524@thunk.org>
References: <E1QsFMR-0001iq-Vt@tytso-glaptop>
 <20110813201419.GA6442@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com,
	Stefan Behrens <sbehrens@giantdisaster.de>
To: Christoph Hellwig <hch@infradead.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52857 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681Ab1HNAoX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 13 Aug 2011 20:44:23 -0400
Content-Disposition: inline
In-Reply-To: <20110813201419.GA6442@infradead.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Aug 13, 2011 at 04:14:19PM -0400, Christoph Hellwig wrote:
> On Sat, Aug 13, 2011 at 10:38:51AM -0400, Theodore Ts'o wrote:
> > 
> > Xfstests #62 was recently enabled by commit b2b36d0a4.
> > 
> > However, this test is failing for ext4 because ext4 doesn't support
> > extended attributes on anything other than regular files and
> > directories.  This is behavior is documented in the attr(5) man page:
> 
> As explained to you before that is not the reason why it fails.  The
> reason is that Andreas Gruenbacher changed return values for certain
> xattr operations in commit 55b23bde19c08f14127a27d461a4e079942c7258.

Apologies, I hadn't yet read your mail message while I started digging
into this failure this morning, and the fact that the files got
reordered from what was expected in the output file confused me into
thinking ext4 was failing tests that where the 062.out file expected
successes, and I juped to conclusions.

I see there's an sort command at the very end of _extend_test_bed(), I
presume we should also add a similar "LC_COLLATE=POSIX sort" to the
other "find" command pipelines, and it's easy enough to filter out the
lost+found directory by adding a "! -name lost+found".

     	  	       		    		 - Ted
