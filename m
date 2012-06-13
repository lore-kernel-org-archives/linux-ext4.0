From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] tests: add two more tests of orphaned inode
 handling
Date: Wed, 13 Jun 2012 09:26:57 -0400
Message-ID: <20120613132657.GA12595@thunk.org>
References: <1339467762-5725-1-git-send-email-tytso@mit.edu>
 <1339479907-19088-1-git-send-email-tytso@mit.edu>
 <1339479907-19088-2-git-send-email-tytso@mit.edu>
 <F7262E20-BC8F-42BE-A8F0-C7DBD49CA8C6@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:49580 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753688Ab2FMN1A (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 13 Jun 2012 09:27:00 -0400
Content-Disposition: inline
In-Reply-To: <F7262E20-BC8F-42BE-A8F0-C7DBD49CA8C6@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jun 13, 2012 at 12:44:10AM -0600, Andreas Dilger wrote:
> > diff --git a/tests/f_orphan_indirect_inode/expect.1 b/tests/f_orphan_indirect_inode/expect.1
> > new file mode 100644
> > index 0000000..33cdd65
> > --- /dev/null
> > +++ b/tests/f_orphan_indirect_inode/expect.1
> > @@ -0,0 +1,2 @@
> > +test_filesys: clean, 12/16 files, 21/100 blocks
> > +Exit status is 0
> 
> Hmm, this doesn't appear to be truncating an orphan inode, unlike
> the f_orphan_extent_inode test is doing?

That's because we're running the test in preen mode, where messages
about the orphan inode processing are suppressed.  The bug that this
test is specifically testing for only happens we don't do a full file
system check, and normally tests run with -fy, which forces a full
check.

I overrode the default options used for the first fs check in this
test to be -p.  I probably should have used -y instead, so that the
orpan inode message didn't get hidden.  I'll fix that for the next
release.

In any case, if you take the image from this test, and run "e2fsck -y
/tmp/image; e2fsck -fy /tmp/image" using the e2fsck from 1.42.3, it'll
become obvious what this test is checking....

						- Ted
