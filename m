From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Remove unused local variable
Date: Sun, 18 Dec 2011 17:40:38 -0500
Message-ID: <20111218224038.GC7226@thunk.org>
References: <1322690524-25028-1-git-send-email-curtw@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:33793 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465Ab1LRWkm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 18 Dec 2011 17:40:42 -0500
Content-Disposition: inline
In-Reply-To: <1322690524-25028-1-git-send-email-curtw@google.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 30, 2011 at 02:02:04PM -0800, Curt Wohlgemuth wrote:
> In get_implied_cluster_alloc(), rr_cluster_end was being
> defined and set, but was never used.  Removed this.
> 
> Signed-off-by: Curt Wohlgemuth <curtw@google.com>

Applied, thanks.

							- Ted
