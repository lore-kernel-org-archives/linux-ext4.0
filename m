From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/2] ext4: Get rid of EXT4_MAP_UNINIT flag
Date: Sat, 12 Apr 2014 10:26:36 -0400
Message-ID: <20140412142636.GE13837@thunk.org>
References: <1397150063-5939-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53186 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769AbaDLO0l (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 12 Apr 2014 10:26:41 -0400
Content-Disposition: inline
In-Reply-To: <1397150063-5939-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Apr 10, 2014 at 07:14:22PM +0200, Lukas Czerner wrote:
> Currently EXT4_MAP_UNINIT is used in dioread_nolock case to mark the
> cases where we're using dioread_nolock and we're writing into either
> unallocated, or unwritten extent, because we need to make sure that
> any DIO write into that inode will wait for the extent conversion.
> 
> However EXT4_MAP_UNINIT is not only entirely misleading name but also
> unnecessary because we can check for EXT4_MAP_UNWRITTEN in the
> dioread_nolock case instead.
> 
> This commit removes EXT4_MAP_UNINIT flag.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, this patch has been queued for 3.16

				   - Ted
