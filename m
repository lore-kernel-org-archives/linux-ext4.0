From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: print more info in ext4_print_free_blocks()
Date: Mon, 1 Apr 2013 11:14:19 -0400
Message-ID: <20130401151419.GD4731@thunk.org>
References: <1363097676-19587-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:57811 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758362Ab3DAPOV (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 1 Apr 2013 11:14:21 -0400
Content-Disposition: inline
In-Reply-To: <1363097676-19587-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 12, 2013 at 03:14:36PM +0100, Lukas Czerner wrote:
> Additionally print i_allocated_meta_blocks information as well.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
