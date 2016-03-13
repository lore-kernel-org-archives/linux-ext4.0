From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [RFC -v2 4/8] jbd, jbd2: Do not fail journal because of
 frozen_buffer allocation failure
Date: Sun, 13 Mar 2016 17:37:26 -0400
Message-ID: <20160313213726.GH29218@thunk.org>
References: <1438768284-30927-1-git-send-email-mhocko@kernel.org>
 <1438768284-30927-5-git-send-email-mhocko@kernel.org>
 <20150818103823.GC5033@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:38954 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbcCMVha (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 13 Mar 2016 17:37:30 -0400
Content-Disposition: inline
In-Reply-To: <20150818103823.GC5033@dhcp22.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 18, 2015 at 12:38:23PM +0200, Michal Hocko wrote:
> From: Michal Hocko <mhocko@suse.com>
> 
> Journal transaction might fail prematurely because the frozen_buffer
> is allocated by GFP_NOFS request:
> [   72.440013] do_get_write_access: OOM for frozen_buffer
> [   72.440014] EXT4-fs: ext4_reserve_inode_write:4729: aborting transaction: Out of memory in __ext4_journal_get_write_access
> [   72.440015] EXT4-fs error (device sda1) in ext4_reserve_inode_write:4735: Out of memory
> (...snipped....)
> [   72.495559] do_get_write_access: OOM for frozen_buffer
> [   72.495560] EXT4-fs: ext4_reserve_inode_write:4729: aborting transaction: Out of memory in __ext4_journal_get_write_access
> [   72.496839] do_get_write_access: OOM for frozen_buffer
> [   72.496841] EXT4-fs: ext4_reserve_inode_write:4729: aborting transaction: Out of memory in __ext4_journal_get_write_access
> [   72.505766] Aborting journal on device sda1-8.
> [   72.505851] EXT4-fs (sda1): Remounting filesystem read-only
> 
> This wasn't a problem until "mm: page_alloc: do not lock up GFP_NOFS
> allocations upon OOM" because small GPF_NOFS allocations never failed.
> This allocation seems essential for the journal and GFP_NOFS is too
> restrictive to the memory allocator so let's use __GFP_NOFAIL here to
> emulate the previous behavior.
> 
> jbd code has the very same issue so let's do the same there as well.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.com>

Applied, thanks.

					- Ted
