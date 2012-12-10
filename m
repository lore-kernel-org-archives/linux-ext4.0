From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Ensure Inode flags consistency are checked in
 build time [V2]
Date: Mon, 10 Dec 2012 15:01:38 -0500
Message-ID: <20121210200138.GB5179@thunk.org>
References: <1354555976-18052-1-git-send-email-cmaiolino@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Carlos Maiolino <cmaiolino@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:37841 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952Ab2LJUBl (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Dec 2012 15:01:41 -0500
Content-Disposition: inline
In-Reply-To: <1354555976-18052-1-git-send-email-cmaiolino@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Dec 03, 2012 at 03:32:56PM -0200, Carlos Maiolino wrote:
> Flags being used by atomic operations in inode flags (e.g.
> ext4_test_inode_flag(), should be consistent with that actually stored in
> inodes, i.e.: EXT4_XXX_FL.
> 
> It ensures that this consistency is checked at build-time, not at run-time.
> 
> Currently, the flags consistency are being checked at run-time, but, there is no
> real reason to not do a build-time check instead of a run-time check. The code
> is comparing macro defined values with enum type variables, where both are
> constants, so, there is no problem in comparing constants at build-time.
> 
> enum variables are treated as constants by the C compiler, according to the C99
> specs (see www.open-std.org/jtc1/sc22/wg14/www/docs/n1124.pdf sec. 6.2.5, item
> 16), so, there is no real problem in comparing an enumeration type at build time
> 
> CC'ing Sergio who helped me to achieve this conclusion, in case there is
> something else we need to discuss.
> 
> Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>

Thanks, applied.

						- Ted
