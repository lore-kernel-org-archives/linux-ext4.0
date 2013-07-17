From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Prevent massive fs corruption if verifying the
 block bitmap fails
Date: Wed, 17 Jul 2013 15:55:03 -0400
Message-ID: <20130717195503.GC26859@thunk.org>
References: <20130717020209.GB5785@blackbox.djwong.org>
 <20130717030832.GB12908@thunk.org>
 <20130717070900.GA5790@blackbox.djwong.org>
 <20130717131951.GC12908@thunk.org>
 <20130717194356.GB5790@blackbox.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:38708 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264Ab3GQTzH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jul 2013 15:55:07 -0400
Content-Disposition: inline
In-Reply-To: <20130717194356.GB5790@blackbox.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 17, 2013 at 12:43:56PM -0700, Darrick J. Wong wrote:
> I also wrote a script that fills a fs, maliciously marks all the fs metadata
> blocks as free, and writes more files to the fs, with the result that you
> corrupt the metadata.  I wonder if it's feasible to modify mballoc to check
> that it's not handing out well known metadata locations to files?

We have that --- it's the block_validity mount option.  I use it
regularly for testing.  It's off by default because it does take a bit
more CPU time for every single block allocation and deallocation.  It
would be useful if someone who had access to fast PCIe-attached flash
tried to measure the CPU utilization of a metadata-intensive workload
(such as fs_mark) with and without block_validity.  If the overhead is
negligible, we could enable this by default, and remove the mount
option.

							- Ted
