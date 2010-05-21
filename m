From: tytso@mit.edu
Subject: Re: [PATCH] ext4: Fix for ext4_mb_collect_stats()
Date: Thu, 20 May 2010 23:15:53 -0400
Message-ID: <20100521031553.GA21568@thunk.org>
References: <AANLkTinpiynL7Jq3RAbMtiye89wEsLjs07ZkxGWGg_lX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Curt Wohlgemuth <curtw@google.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38170 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab0EUDPz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 May 2010 23:15:55 -0400
Content-Disposition: inline
In-Reply-To: <AANLkTinpiynL7Jq3RAbMtiye89wEsLjs07ZkxGWGg_lX@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 03, 2010 at 10:26:43AM -0700, Curt Wohlgemuth wrote:
> Fix ext4_mb_collect_stats() to use the correct test for s_bal_success; it
> should be testing "best-extent.fe_len >= orig-extent.fe_len" , not
> "orig-extent.fe_len >= goal-extent.fe_len" .
> 
> Signed-off-by: Curt Wohlgemuth <curtw@google.org>

Added to the ext4 patch queue.

					- Ted
