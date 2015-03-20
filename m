From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fs corruption recovery
Date: Thu, 19 Mar 2015 21:47:08 -0400
Message-ID: <20150320014708.GA3425@thunk.org>
References: <550A1EBF.2030902@linux.vnet.ibm.com>
 <3D9B0893-DA8D-41D1-8782-BC966B91D44D@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Allison Henderson <achender@linux.vnet.ibm.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"jane@us.ibm.com" <jane@us.ibm.com>,
	"marcel.dufour@ca.ibm.com" <marcel.dufour@ca.ibm.com>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50761 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbbCTBrP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Mar 2015 21:47:15 -0400
Content-Disposition: inline
In-Reply-To: <3D9B0893-DA8D-41D1-8782-BC966B91D44D@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Mar 18, 2015 at 06:59:52PM -0600, Andreas Dilger wrote:
> I think that running a 17TB filesystem on ext3 is a recipe for disaster.  They should use ext4 for anything larger than 16TB.

It's not *possible* to have a 17TB file system with ext3.  Something
must be very wrong there.  16TB is the maximum you can have before you
end up overflowing a 32-bit block number.  Unless this is a PowerPC
with a 16K block size or some such?

If e2fsck is segfaulting, then I would certainly try getting the
latest version of e2fsprogs, just in case the problem isn't just that
it's running out of memory.  Also if recovering customer data is the
most important thing, the first thing they should do is a make image
copy of the file system, since it's possible that incorrect use of
e2fsck, or an old/buggy version of e2fsck could make things work.

In particular, if they are seeing errors with multply claimed inodes,
it's likely that part of the inode table was written to the wrong
place, and sometimes a skilled human being can get more data than
simply using e2fsck -y and praying.  At the end of the day the
question is how much is the customer data work and how much effort is
the customer / IBM willing to invest in trying to get every last bit
of data back?

						- Ted
