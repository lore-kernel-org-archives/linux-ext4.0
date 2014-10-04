From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] misc: fix build on absence of magic.h
Date: Sat, 4 Oct 2014 13:24:03 -0400
Message-ID: <20141004172403.GA13163@thunk.org>
References: <1411277306-29807-1-git-send-email-tytso@mit.edu>
 <1412337518-2250-1-git-send-email-artemiyv@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, darrick.wong@oracle.com
To: Artemiy Volkov <artemiyv@acm.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36578 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934AbaJDRYK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 4 Oct 2014 13:24:10 -0400
Content-Disposition: inline
In-Reply-To: <1412337518-2250-1-git-send-email-artemiyv@acm.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 03, 2014 at 09:58:38PM +1000, Artemiy Volkov wrote:
> If magic.h is not present, there will be unresolved references to the magic_t
> type in plausible.c. Fix that by moving the protecting #ifdef directive.
> 
> Signed-off-by: Artemiy Volkov <artemiyv@acm.org>

Applied, thanks.

					- Ted
