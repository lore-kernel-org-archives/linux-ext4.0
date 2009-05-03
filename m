From: Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH] blkid: use /sys/block/dm-<N>/dm/name
Date: Sat, 2 May 2009 22:41:50 -0400
Message-ID: <20090503024150.GB25826@mit.edu>
References: <1240837258-5440-1-git-send-email-kzak@redhat.com> <1240837258-5440-2-git-send-email-kzak@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Eric Sandeen <sandeen@redhat.com>,
	Milan Broz <mbroz@redhat.com>
To: Karel Zak <kzak@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:53438 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730AbZECCly (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 May 2009 22:41:54 -0400
Content-Disposition: inline
In-Reply-To: <1240837258-5440-2-git-send-email-kzak@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Apr 27, 2009 at 03:00:58PM +0200, Karel Zak wrote:
> The Linux kernel (since 2.6.29, patch 784aae735d9b0bba3f8b9faef4c8b30df3bf0128)
> exports the real DM device names in /sys/block/<ptname>/dm/name.

Thanks, applied.

					- Ted
