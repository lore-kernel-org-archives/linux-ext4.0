From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/6] ext4: remove messy logic from ext4_ext_rm_leaf
Date: Tue, 25 Oct 2011 07:44:06 -0400
Message-ID: <20111025114406.GE31921@thunk.org>
References: <1319144939-28801-1-git-send-email-dmonakhov@openvz.org>
 <1319144939-28801-5-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, achender@linux.vnet.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40686 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932198Ab1JYLoP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 25 Oct 2011 07:44:15 -0400
Content-Disposition: inline
In-Reply-To: <1319144939-28801-5-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 21, 2011 at 01:08:57AM +0400, Dmitry Monakhov wrote:
> - Both callers(truncate and punch_hole) already aligned left end point
>   so we no longer need split logic here.
> - Remove dead duplicated code.
> - Call ext4_ext_dirty only after we have updated eh_entries, otherwise
>   we'll loose entries update. Regression caused by d583fb87a3ff0
>   266'th testcase in xfstests (http://patchwork.ozlabs.org/patch/120872)
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Thanks, applied

					- Ted
