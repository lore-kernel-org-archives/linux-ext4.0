From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix comparison endianness problem in MMP
 initialization
Date: Sat, 8 Oct 2011 17:27:44 -0400
Message-ID: <20111008212744.GP7948@thunk.org>
References: <20110930194900.GY12086@tux1.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
	linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:54798 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753790Ab1JHV1p (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 8 Oct 2011 17:27:45 -0400
Content-Disposition: inline
In-Reply-To: <20110930194900.GY12086@tux1.beaverton.ibm.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Sep 30, 2011 at 12:49:00PM -0700, Darrick J. Wong wrote:
> As part of startup, the MMP initialization code does this:
> 
> mmp->mmp_seq = seq = cpu_to_le32(mmp_new_seq());
> 
> Next, mmp->mmp_seq is written out to disk, a delay happens, and then the MMP
> block is read back in and the sequence value is tested:
> 
> if (seq != le32_to_cpu(mmp->mmp_seq)) {
> 	/* fail the mount */
> 
> On a LE system such as x86, the *le32* functions do nothing and this works.
> Unfortunately, on a BE system such as ppc64, this comparison becomes:
> 
> if (cpu_to_le32(new_seq) != le32_to_cpu(cpu_to_le32(new_seq)) {
> 	/* fail the mount */
> 
> Except for a few palindromic sequence numbers, this test always causes the
> mount to fail, which makes MMP filesystems generally unmountable on ppc64.  The
> attached patch fixes this situation.
> 
> (This fix came up while testing the metadata checksumming patchset)
> 
> Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

Applied, thanks.

						- Ted
