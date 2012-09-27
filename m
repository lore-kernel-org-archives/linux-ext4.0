From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: enable FITRIM ioctl on bigalloc file system
Date: Wed, 26 Sep 2012 22:28:10 -0400
Message-ID: <20120927022810.GC15707@thunk.org>
References: <1341342642-4156-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:52620 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab2I0C2O (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 26 Sep 2012 22:28:14 -0400
Content-Disposition: inline
In-Reply-To: <1341342642-4156-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 03, 2012 at 09:10:42PM +0200, Lukas Czerner wrote:
> With a minor tweaks regarding minimum extent size to discard and
> discarded bytes reporting the FITRIM can be enabled on bigalloc file
> system and it works without any problem.
> 
> This patch fixes minlen handling and discarded bytes reporting to
> take into consideration bigalloc enabled file systems and finally
> removes the restriction and allow FITRIM to be used on file system with
> bigalloc feature enabled.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Applied, thanks!

						- Ted
