From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 1/2] ext4: Preallocation is a multiple of stripe size
Date: Sun, 17 Jul 2011 21:13:15 -0400
Message-ID: <20110718011315.GH2717@thunk.org>
References: <1310766115-4164-1-git-send-email-dehrenberg@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	Eric Sandeen <sandeen@redhat.com>
To: Dan Ehrenberg <dehrenberg@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50892 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752362Ab1GRBNS (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 17 Jul 2011 21:13:18 -0400
Content-Disposition: inline
In-Reply-To: <1310766115-4164-1-git-send-email-dehrenberg@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 15, 2011 at 02:41:54PM -0700, Dan Ehrenberg wrote:
> Previously, if a stripe width was provided, then it would be used
> as the preallocation granularity, with no santiy checking and no
> way to override this. Now, mb_prealloc_size defaults to the smallest
> multiple of stripe size that is greater than or equal to the old
> default mb_prealloc_size, and this can be overridden with the sysfs
> interface.
> 
> Signed-off-by: Dan Ehrenberg <dehrenberg@google.com>

Added to the ext4 tree, thanks!

					- Ted

