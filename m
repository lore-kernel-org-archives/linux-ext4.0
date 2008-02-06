From: Karel Zak <kzak@redhat.com>
Subject: Re: [PATCH 0/3] Move fsck from e2fsprogs to util-linux-ng
Date: Wed, 6 Feb 2008 13:56:51 +0100
Message-ID: <20080206125651.GD558@petra.dvoda.cz>
References: <20080206113426.7833.59505.stgit@sor.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: util-linux-ng@vger.kernel.org, linux-ext4@vger.kernel.org
To: Matthias Koenig <mkoenig@suse.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762583AbYBFM4z (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 6 Feb 2008 07:56:55 -0500
Content-Disposition: inline
In-Reply-To: <20080206113426.7833.59505.stgit@sor.suse.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 06, 2008 at 12:38:59PM +0100, Matthias Koenig wrote:
> Here is another attempt to move fsck over to the util-linux-ng
> tree. A similar attempt has been done previously by Christoph
> Hellwig some time ago.

Thanks (also thanks to Christoph)!

I didn't forget about this task. It's still in my TODO list.

It seems that the fsck wrapper in e2fsprogs is optional
(--enable-fsck) so we needn't any extra change to e2fsprogs.

It would be nice to add a note

    "fsck is deprecated in favor of fsck from util-linux-ng"

to RELEASE-NOTES in e2fsprogs.

> Patch 1 is the initial move with minor adjustments for the
> build system.
> Patch 2 adds support for the fsprobe library wrapper.

What about to move the fsprobe library wrapper to lib/ ?

> Patch 3 adds a new option which has been in Suse for some
> time to ignore mounted filesystems.

We also need a --disable-fsck configure option.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
