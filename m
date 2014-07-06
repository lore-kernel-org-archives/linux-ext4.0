From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 2/2] mke2fs: Enable lazy_itable_init on newer kernel by
 default
Date: Sat, 5 Jul 2014 21:09:29 -0400
Message-ID: <20140706010929.GD19036@thunk.org>
References: <1393263666-21246-1-git-send-email-lczerner@redhat.com>
 <1393263666-21246-2-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47148 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190AbaGFBJb (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 5 Jul 2014 21:09:31 -0400
Content-Disposition: inline
In-Reply-To: <1393263666-21246-2-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Feb 24, 2014 at 06:41:06PM +0100, Lukas Czerner wrote:
> Currently is used did not specified lazy_itable_init option we rely on
> information from ext4 module exported via sysfs interface. However if
> the ext4 module is not loaded it will not be enabled even though kernel
> might support it.
> 
> With this commit we set the default according to the kernel version,
> however we still allow it to be set manually via extended option or be
> enabled in case that ext4 module advertise that it supports this
> feature.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
