From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: support GETFSMAP ioctls
Date: Sun, 30 Apr 2017 00:39:47 -0400
Message-ID: <20170430043947.imidaltdkm3jzuqn@thunk.org>
References: <20170423195759.GB3972@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33632 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S940032AbdD3Eju (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 30 Apr 2017 00:39:50 -0400
Content-Disposition: inline
In-Reply-To: <20170423195759.GB3972@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Apr 23, 2017 at 12:57:59PM -0700, Darrick J. Wong wrote:
> Support the GETFSMAP ioctls so that we can use the xfs free space
> management tools to probe ext4 as well.  Note that this is a partial
> implementation -- we only report fixed-location metadata and free space;
> everything else is reported as "unknown".
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

					- Ted
