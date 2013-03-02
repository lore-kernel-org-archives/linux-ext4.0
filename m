From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Convert number of blocks to clusters properly
Date: Sat, 2 Mar 2013 17:19:37 -0500
Message-ID: <20130302221937.GD22941@thunk.org>
References: <1361967954-20586-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:50959 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab3CBWTk (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sat, 2 Mar 2013 17:19:40 -0500
Content-Disposition: inline
In-Reply-To: <1361967954-20586-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Feb 27, 2013 at 01:25:54PM +0100, Lukas Czerner wrote:
> We're using macro EXT4_B2C() to convert number of blocks to number of
> clusters, however we should be using EXT4_NUM_B2C(). Fix that.
> 
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>

Thanks, applied.

					- Ted
