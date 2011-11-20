From: Ted Ts'o <tytso@mit.edu>
Subject: Re: debugfs: Fix sprintf stack overflow
Date: Sun, 20 Nov 2011 15:47:58 -0500
Message-ID: <20111120204758.GA14791@thunk.org>
References: <20111012010221.GN12447@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59665 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751471Ab1KTUsE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 20 Nov 2011 15:48:04 -0500
Content-Disposition: inline
In-Reply-To: <20111012010221.GN12447@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Oct 11, 2011 at 03:02:21PM -0000, Darrick J. Wong wrote:
> The htree dump code overflows a char buffer if the directory has a long
> filename because the buffer is not large enough to hold the characters that are
> not part of the filename.  Make the buffer larger and use snprintf instead.
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied.

					- Ted
