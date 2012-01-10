From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH RESEND] ext4: fix undefined behavior in
 ext4_fill_flex_info()
Date: Tue, 10 Jan 2012 11:54:40 -0500
Message-ID: <20120110165440.GA6034@thunk.org>
References: <1326152840-1188-1-git-send-email-xi.wang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
To: Xi Wang <xi.wang@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:59908 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932088Ab2AJQyo (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 10 Jan 2012 11:54:44 -0500
Content-Disposition: inline
In-Reply-To: <1326152840-1188-1-git-send-email-xi.wang@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 09, 2012 at 06:47:20PM -0500, Xi Wang wrote:
> Commit 503358ae01b70ce6909d19dd01287093f6b6271c ("ext4: avoid divide by
> zero when trying to mount a corrupted file system") fixes CVE-2009-4307
> by performing a sanity check on s_log_groups_per_flex, since it can be
> set to a bogus value by an attacker.
> 
> 	sbi->s_log_groups_per_flex = sbi->s_es->s_log_groups_per_flex;
> 	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
> 
> 	if (groups_per_flex < 2) { ... }
> 
> This patch fixes two potential issues in the previous commit.
> 
> 1) The sanity check might only work on architectures like PowerPC.
> On x86, 5 bits are used for the shifting amount.  That means, given a
> large s_log_groups_per_flex value like 36, groups_per_flex = 1 << 36
> is essentially 1 << 4 = 16, rather than 0.  This will bypass the check,
> leaving s_log_groups_per_flex and groups_per_flex inconsistent.
> 
> 2) The sanity check relies on undefined behavior, i.e., oversized shift.
> A standard-confirming C compiler could rewrite the check in unexpected
> ways.  Consider the following equivalent form, assuming groups_per_flex
> is unsigned for simplicity.
> 
> 	groups_per_flex = 1 << sbi->s_log_groups_per_flex;
> 	if (groups_per_flex == 0 || groups_per_flex == 1) {
> 
> We compile the code snippet using Clang 3.0 and GCC 4.6.  Clang will
> completely optimize away the check groups_per_flex == 0, leaving the
> patched code as vulnerable as the original.  GCC keeps the check, but
> there is no guarantee that future versions will do the same.
> 
> Signed-off-by: Xi Wang <xi.wang@gmail.com>
> Cc: stable@vger.kernel.org

Thanks, applied.  And thanks for the expanded commit description!

		      	     	     - Ted
