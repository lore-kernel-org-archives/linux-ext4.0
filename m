From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: libext2fs: delete unused "handle" variable
Date: Thu, 20 Feb 2014 19:59:57 -0500
Message-ID: <20140221005957.GA29199@thunk.org>
References: <52BE85DD.7060902@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: jon ernst <jonernst07@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:60622 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728AbaBUBAG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 20 Feb 2014 20:00:06 -0500
Content-Disposition: inline
In-Reply-To: <52BE85DD.7060902@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, Dec 28, 2013 at 03:03:41AM -0500, jon ernst wrote:
> [PATCH] libext2fs: delete unused "handle" variable
> after commit 62f17f36031102a2a40fac338e063c556f73b94a,
> variable "handle" has no use. So delete it.
> 
> Signed-off-by: Jon Enrst <jonernst07@gmail.com>

Thanks, applied.  (Apologies for the delay)

					- Ted
