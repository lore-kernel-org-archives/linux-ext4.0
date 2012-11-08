From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Notify when discard is not supported
Date: Thu, 8 Nov 2012 13:28:12 -0500
Message-ID: <20121108182812.GF19977@thunk.org>
References: <1350648758-3318-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60091 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756707Ab2KHWVC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 8 Nov 2012 17:21:02 -0500
Content-Disposition: inline
In-Reply-To: <1350648758-3318-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Oct 19, 2012 at 02:12:37PM +0200, Lukas Czerner wrote:
> Notify user when mounting the file system with -o discard option, but
> the device does not support discard. Obviously we do not want to fail
> the mount or disable the options, because the underlying device might
> change in future even without file system remount.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
