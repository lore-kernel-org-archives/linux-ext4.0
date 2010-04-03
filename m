From: tytso@mit.edu
Subject: Re: [PATCH] ext4: fix quota accounting in case of fallocate
Date: Sat, 3 Apr 2010 11:56:58 -0400
Message-ID: <20100403155658.GP8298@thunk.org>
References: <1269959076-9591-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, aneesh.kumar@linux.vnet.ibm.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59383 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab0DCP5B (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 3 Apr 2010 11:57:01 -0400
Content-Disposition: inline
In-Reply-To: <1269959076-9591-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 30, 2010 at 06:24:35PM +0400, Dmitry Monakhov wrote:
> allocated_meta_data is already included in 'used' variable.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Thanks, added to the ext4 patch queue.

-- Ted
