From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Make ext4_ext_convert_to_initialized() return
 proper number of blocks
Date: Thu, 30 Oct 2014 10:45:34 -0400
Message-ID: <20141030144534.GC31927@thunk.org>
References: <1413966550-27404-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53223 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759987AbaJ3Opj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 30 Oct 2014 10:45:39 -0400
Content-Disposition: inline
In-Reply-To: <1413966550-27404-1-git-send-email-jack@suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Oct 22, 2014 at 10:29:10AM +0200, Jan Kara wrote:
> ext4_ext_convert_to_initialized() can return more blocks than are
> actually allocated from map->m_lblk in case where initial part of the
> on-disk extent is zeroed out. Luckily this doesn't have serious
> consequences because the caller currently uses the return value
> only to unmap metadata buffers. Anyway this is a data
> corruption/exposure problem waiting to happen so fix it.
> 
> Coverity-id: 1226848
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
