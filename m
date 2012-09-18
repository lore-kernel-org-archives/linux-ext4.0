From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Anyone have test cases for SEEK_HOLE/SEEK_DATA?
Date: Tue, 18 Sep 2012 14:15:56 -0400
Message-ID: <20120918181556.GC28689@thunk.org>
References: <nsxa9wojdcd.fsf@closure.thunk.org>
 <20120918064039.GS11511@dastard>
 <50588898.6050802@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:51356 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752930Ab2IRSQA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Sep 2012 14:16:00 -0400
Content-Disposition: inline
In-Reply-To: <50588898.6050802@sgi.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Sep 18, 2012 at 09:43:36AM -0500, Mark Tinguely wrote:
> xfstest 285 and 286 (I believe these tests were only in the OSS
> version and not in the kernel.org developers version of xfstests).

Hi Mark,

Could you clarify what the relationship is between the OSS xfstests
tree and the one on kernel.org?  Is the OSS tree always ahead of the
kernel.org tree (i.e., are the commits in the OSS tree a superset of
the ones in the kernel.org tree)?

I had been under the impression that commits flowed from the
kernel.org tree to the OSS tree, but it sounds like I was misinformed
on that point?

Thanks,

						- Ted
