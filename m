From: tytso@mit.edu
Subject: Re: [PATCH 1/2] Jbd: fix an assertion, jh->b_transaction should be
Date: Wed, 24 Feb 2010 12:13:06 -0500
Message-ID: <20100224171306.GI5166@thunk.org>
References: <1264391104-10950-1-git-send-email-dingdinghua@nrchpc.ac.cn>
 <1264391104-10950-2-git-send-email-dingdinghua@nrchpc.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: dingdinghua <dingdinghua@nrchpc.ac.cn>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:53598 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755063Ab0BXRNH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Feb 2010 12:13:07 -0500
Content-Disposition: inline
In-Reply-To: <1264391104-10950-2-git-send-email-dingdinghua@nrchpc.ac.cn>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 25, 2010 at 11:45:03AM +0800, dingdinghua wrote:
> ---
>  fs/jbd/commit.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)

Acked-by: "Theodore Ts'o" <tytso@mit.edu>

(Sorry, I replied to the wrong mail message in my previous note; I've
put the jbd2 version of this patch in the ext4 patch queue, and I'm
acking this for Jan.)

					- Ted
