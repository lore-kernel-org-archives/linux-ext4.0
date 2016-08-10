From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fsck: fix strange logic
Date: Wed, 10 Aug 2016 17:40:28 -0400
Message-ID: <20160810214028.GB10523@thunk.org>
References: <1470773576-18604-1-git-send-email-andreas.dilger@intel.com>
 <0F4CAD2B-88EB-4727-8937-E50D776F3264@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42228 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932298AbcHJVka (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Aug 2016 17:40:30 -0400
Content-Disposition: inline
In-Reply-To: <0F4CAD2B-88EB-4727-8937-E50D776F3264@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 09, 2016 at 02:26:21PM -0600, Andreas Dilger wrote:
> I'll push a v2 patch that keeps the original logic, and Ted can choose
> which one is correct.
>

The original logic is what's intended.  What's going on here is that
the argument to -C is optional (for backwards compatibility reasons),
and we know it's always going to be a positive integer, since it's a
file descriptor.  If the next argument begins with a '-', it must be
an option specifier, and the argument to -C was missing.  If the next
argument does not begin with a '-', then we try to parse it as an
integer, and we rely on the fact that in general the device specifier
to fsck generally begins with a '/', and if not, isn't going to be
parseable as a number.

						- Ted
