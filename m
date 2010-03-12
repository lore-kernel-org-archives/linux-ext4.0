From: tytso@mit.edu
Subject: Re: [PATCH] mke2fs: skip alignment questioning if -F specified
Date: Thu, 11 Mar 2010 21:48:31 -0500
Message-ID: <20100312024831.GN1497@thunk.org>
References: <4B8C1B25.5050006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:41945 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754857Ab0CLCse (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 11 Mar 2010 21:48:34 -0500
Content-Disposition: inline
In-Reply-To: <4B8C1B25.5050006@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Mar 01, 2010 at 01:53:09PM -0600, Eric Sandeen wrote:
> RH bug 569021 - mke2fs insists on user interaction even if stdin is not a tty and -F is passed
> 
> This is just a warning, -F should easily override it.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Applied to the maint branch.

				- Ted
