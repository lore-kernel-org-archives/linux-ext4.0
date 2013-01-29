From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2] ext4: remove unused variable flags
Date: Mon, 28 Jan 2013 21:14:47 -0500
Message-ID: <20130129021447.GD7003@thunk.org>
References: <1359364399-4504-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:45954 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751958Ab3A2COu (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jan 2013 21:14:50 -0500
Content-Disposition: inline
In-Reply-To: <1359364399-4504-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jan 28, 2013 at 10:13:19AM +0100, Lukas Czerner wrote:
> Remove unused variable flags from dump_completed_IO(). The code is only
> exercised when EXT4FS_DEBUG is defined.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>

Thanks, applied.

					- Ted
