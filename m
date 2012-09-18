From: Ben Myers <bpm@sgi.com>
Subject: Re: Anyone have test cases for SEEK_HOLE/SEEK_DATA?
Date: Tue, 18 Sep 2012 13:28:41 -0500
Message-ID: <20120918182841.GA3343@sgi.com>
References: <nsxa9wojdcd.fsf@closure.thunk.org>
 <20120918064039.GS11511@dastard>
 <50588898.6050802@sgi.com>
 <20120918181556.GC28689@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Mark Tinguely <tinguely@sgi.com>,
	Dave Chinner <david@fromorbit.com>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	xfs@oss.sgi.com
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from relay3.sgi.com ([192.48.152.1]:58928 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750862Ab2IRS2q (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 18 Sep 2012 14:28:46 -0400
Content-Disposition: inline
In-Reply-To: <20120918181556.GC28689@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hey Ted,

On Tue, Sep 18, 2012 at 02:15:56PM -0400, Theodore Ts'o wrote:
> On Tue, Sep 18, 2012 at 09:43:36AM -0500, Mark Tinguely wrote:
> > xfstest 285 and 286 (I believe these tests were only in the OSS
> > version and not in the kernel.org developers version of xfstests).
> 
> Could you clarify what the relationship is between the OSS xfstests
> tree and the one on kernel.org?  Is the OSS tree always ahead of the
> kernel.org tree (i.e., are the commits in the OSS tree a superset of
> the ones in the kernel.org tree)?

The trees on kernel.org are being retired.  I'm not sure what Christoph is
going to do with the kernel.org repos, but expect new changes to go directly
into the xfstests repo on oss.sgi.com.

> I had been under the impression that commits flowed from the
> kernel.org tree to the OSS tree, but it sounds like I was misinformed
> on that point?

Your impression is just a few days out of date.  See:

http://oss.sgi.com/archives/xfs/2012-09/msg00156.html

Regards,
	Ben
