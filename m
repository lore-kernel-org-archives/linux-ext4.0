From: tytso@mit.edu
Subject: Re: move __func__ into a macro for ext4_warning, ext4_error
Date: Mon, 15 Feb 2010 14:20:07 -0500
Message-ID: <20100215192007.GA5003@thunk.org>
References: <4B58AA0C.4040602@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:59809 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756031Ab0BOTUN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 15 Feb 2010 14:20:13 -0500
Content-Disposition: inline
In-Reply-To: <4B58AA0C.4040602@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 21, 2010 at 09:25:00AM -0000, Eric Sandeen wrote:
> Just a pet peeve of mine; we had a mishash of calls with either __func__
> or "function_name" and the latter tends to get out of sync.
> 
> I think it's easier to just hide the __func__ in a macro, and it'll
> be consistent from then on.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Thanks, applied to the ext4 patch queue.

						- Ted
