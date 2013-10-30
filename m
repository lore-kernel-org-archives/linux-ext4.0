From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Don't count free clusters from a corrupt block
 group
Date: Wed, 30 Oct 2013 11:21:57 -0400
Message-ID: <20131030152157.GB13343@thunk.org>
References: <20130928001349.25857.76724.stgit@birch.djwong.org>
 <20130928001357.25857.94425.stgit@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, gnehzuil.liu@gmail.com
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52496 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076Ab3J3Qu7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Oct 2013 12:50:59 -0400
Content-Disposition: inline
In-Reply-To: <20130928001357.25857.94425.stgit@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 27, 2013 at 05:13:57PM -0700, Darrick J. Wong wrote:
> A bg that's been flagged "corrupt" by definition has no free blocks, so that
> the allocator won't be tempted to use the damaged bg.  Therefore, we shouldn't
> count the clusters in the damaged group when calculating free counts.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
