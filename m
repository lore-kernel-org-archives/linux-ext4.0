From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] e2fsck: fix problem report typo
Date: Sun, 6 Mar 2016 22:06:06 -0500
Message-ID: <20160307030606.GH30238@thunk.org>
References: <20160107183118.GB8716@localhost.localdomain>
 <20160107184403.GB28338@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Whitney <enwlinux@gmail.com>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38690 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341AbcCGDGK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 6 Mar 2016 22:06:10 -0500
Content-Disposition: inline
In-Reply-To: <20160107184403.GB28338@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 07, 2016 at 10:44:03AM -0800, Darrick J. Wong wrote:
> On Thu, Jan 07, 2016 at 01:31:18PM -0500, Eric Whitney wrote:
> > Remove the stray left parenthesis.  Observed while testing bigalloc_1k
> > filesystems with shared/298 on 32 bit ARM running 4.3 kernels.
> > 
> > v2: Modify the expect files for the relevant regression tests.
> 
> Looks ok now,
> Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

							- Ted
