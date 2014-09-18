From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] ext4: Explicitly inform user about orphan list
 cleanup.
Date: Thu, 18 Sep 2014 00:29:07 -0400
Message-ID: <20140918042907.GD24887@thunk.org>
References: <1410698337-27454-1-git-send-email-dmonakhov@openvz.org>
 <1410698337-27454-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35047 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbaIRE3L (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 18 Sep 2014 00:29:11 -0400
Content-Disposition: inline
In-Reply-To: <1410698337-27454-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Sep 14, 2014 at 04:38:57PM +0400, Dmitry Monakhov wrote:
> Production fs likely compiled/mounted w/o jbd debugging, so orphan list clearing
> will be silent.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

Thanks, applied.

					- Ted
