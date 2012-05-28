From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove needs_recovery in ext4_mb_init()
Date: Mon, 28 May 2012 13:59:19 -0400
Message-ID: <20120528175919.GK19152@thunk.org>
References: <4F8786EC.1000302@rs.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Akira Fujita <a-fujita@rs.jp.nec.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46034 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753188Ab2E1R7V (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 May 2012 13:59:21 -0400
Content-Disposition: inline
In-Reply-To: <4F8786EC.1000302@rs.jp.nec.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Apr 13, 2012 at 10:52:44AM +0900, Akira Fujita wrote:
> needs_recovery in ext4_mb_init() is not used,
> remove it.
> 
> Signed-off-by: Akira Fujita <a-fujita@rs.jp.ne.com>

Applied, thanks.

					- Ted
