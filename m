From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] e4defrag: fix GCC7.x compiler warning
Date: Wed, 28 Jun 2017 13:29:34 -0400
Message-ID: <20170628172934.lsyy5waijlmcm7xu@thunk.org>
References: <17cefd39-75bf-45e5-38fa-2eac38f6e081@dragonfly.plus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Marc Thomas <marc@dragonfly.plus.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55352 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751559AbdF1Uj1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 28 Jun 2017 16:39:27 -0400
Content-Disposition: inline
In-Reply-To: <17cefd39-75bf-45e5-38fa-2eac38f6e081@dragonfly.plus.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jun 26, 2017 at 04:40:39PM +0100, Marc Thomas wrote:
> ../../misc/e4defrag.c:1821:8: warning: statement will never be executed
> [-Wswitch-unreachable]
>     int mount_dir_len = 0;
> 
> Also fix a typo in a few comments.
> 
> Signed-off-by: Marc Thomas <marc@dragonfly.plus.com>

Applied, thanks.  (Again, the patch was somehow damaged, but I was able
to figure out what you were trying to change.)

   	      	       	    	   - Ted
