From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Replace open coded mdata csum feature to
 helper function v2
Date: Mon, 13 Oct 2014 03:59:30 -0400
Message-ID: <20141013075930.GA9738@thunk.org>
References: <1413147967-30487-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:49506 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbaJMH7l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 13 Oct 2014 03:59:41 -0400
Content-Disposition: inline
In-Reply-To: <1413147967-30487-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Oct 13, 2014 at 01:06:06AM +0400, Dmitry Monakhov wrote:
> Besides the fact that this replacement improves code readability
> it also protects from errors caused direct EXT4_S(sb)->s_es manipulation
> which may result attempt to use uninitialized  csum machinery.

Thanks, applied.

					- Ted
