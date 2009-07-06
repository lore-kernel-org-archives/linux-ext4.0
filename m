From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Add a missing return in
	ext4_ext_calc_credits_for_single_extent
Date: Sun, 5 Jul 2009 23:13:48 -0400
Message-ID: <20090706031348.GA31532@mit.edu>
References: <1246618556-1524-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cmm@us.ibm.com, sandeen@redhat.com, linux-ext4@vger.kernel.org
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:37918 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbZGFDNt (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 5 Jul 2009 23:13:49 -0400
Content-Disposition: inline
In-Reply-To: <1246618556-1524-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Jul 03, 2009 at 04:25:56PM +0530, Aneesh Kumar K.V wrote:
> When we have space in the extent tree leaf node we should be able to
> insert the extent with much less journal credits. The code was doing
> proper calculation but missed a return statement.
> 
> Reported-by:Andreas Dilger <adilger@sun.com>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Thanks, added to the ext4 patch queue.

						- Ted
