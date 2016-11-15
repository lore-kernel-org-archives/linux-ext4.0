From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: ext4_mb_mark_free_simple: Fix integer value
 truncation
Date: Mon, 14 Nov 2016 21:24:20 -0500
Message-ID: <20161115022420.7bgsyq3yz6sxv3sk@thunk.org>
References: <1478164472-28376-1-git-send-email-chandan@linux.vnet.ibm.com>
 <2AE0DCBF-5AB6-47B2-B9F6-B738AFF2EAF2@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        linux-ext4@vger.kernel.org, jack@suse.cz,
        aneesh.kumar@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:37142 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932906AbcKOCY1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Mon, 14 Nov 2016 21:24:27 -0500
Content-Disposition: inline
In-Reply-To: <2AE0DCBF-5AB6-47B2-B9F6-B738AFF2EAF2@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Nov 03, 2016 at 01:32:33PM -0600, Andreas Dilger wrote:
> On Nov 3, 2016, at 3:14 AM, Chandan Rajendra <chandan@linux.vnet.ibm.com> wrote:
> > 
> > 'border' variable is set to a value of 2 times the block size of the
> > underlying filesystem. With 64k block size, the resulting value won't
> > fit into a 16-bit variable. Hence this commit changes the data type of
> > 'border' to 'unsigned int'.
> > 
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>

Applied, with a change in the commit summary:

    ext4: fix mballoc breakage with 64k block size

Many thanks!!

					- Ted
