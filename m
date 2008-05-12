From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] libuuid: don't use unitialized variable
Date: Sun, 11 May 2008 20:41:49 -0400
Message-ID: <20080512004149.GB25012@mit.edu>
References: <n7xhcdbd5mw.fsf@sor.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Matthias Koenig <mkoenig@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from www.church-of-our-saviour.org ([69.25.196.31]:49422 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751038AbYELDW1 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 11 May 2008 23:22:27 -0400
Content-Disposition: inline
In-Reply-To: <n7xhcdbd5mw.fsf@sor.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, May 06, 2008 at 01:38:31PM +0200, Matthias Koenig wrote:
> Hi,
> 
> tv is not initialized before the assigment to last.
> 
> Signed-Off-By: Matthias Koenig <mkoenig@suse.de>

Thanks, applied.

						- Ted
