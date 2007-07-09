From: Kalpak Shah <kalpak@clusterfs.com>
Subject: Re: [e2fsprogs] Bug in salvage_directory
Date: Mon, 09 Jul 2007 23:22:05 +0530
Message-ID: <1184003549.4347.6.camel@garfield>
References: <1183973522.3889.10.camel@garfield.linsyssoft.com>
	 <20070709165016.GA21922@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from 74-0-229-162.T1.lbdsl.net ([74.0.229.162]:42285 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235AbXGIRyG (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 9 Jul 2007 13:54:06 -0400
In-Reply-To: <20070709165016.GA21922@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-07-09 at 12:50 -0400, Theodore Tso wrote:
> On Mon, Jul 09, 2007 at 03:02:02PM +0530, Kalpak Shah wrote:
> > Hi Ted,
> > 
> > Recently, one of our customers found this message in pass2 of e2fsck while doing some regression testing:
> > "Entry '4, 0x695a, 0x81ff, 0x0040, 0x8320, 0xa192, 0x0021' in ??? (136554) has
> > rec_len of 14200, should be 26908."
> > 
> > Both the displayed rec_len and the "should be" value are bogus. The
> > reason is that salvage_directory sets a offset beyond blocksize
> > leading to bogus messages.
> 
> Do you have a test case where this happens?  I don't think your patch
> is right, because if dirent->rec_len is too big, this yes, your patch
> will make sure offset doesn't get set beyond fs->blocksize, but it
> ends up leaving prev->rec_len also pointing beyond fs->blocksize ---
> which means a 2nd e2fsck should result in a complaint about that.

Yes even prev->rec_len cannot be beyond fs->blocksize. I do have the
corrupt filesystem image but it is a large one. 

This patch certainly works well and corrects the problem in a single run
of e2fsck.

Thanks,
Kalpak.
