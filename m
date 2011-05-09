From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [Patch] ext4: remove a useless #ifdef in super.c
Date: Sun, 8 May 2011 22:04:57 -0400
Message-ID: <20110509020457.GG4138@thunk.org>
References: <1302069721-19718-1-git-send-email-amwang@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Amerigo Wang <amwang@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:60048 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab1EICFC (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 8 May 2011 22:05:02 -0400
Content-Disposition: inline
In-Reply-To: <1302069721-19718-1-git-send-email-amwang@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Apr 06, 2011 at 02:02:01PM +0800, Amerigo Wang wrote:
> There is already an #ifdef CONFIG_QUOTA some lines above,
> so this one is totally useless.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>

Thanks, added to the ext4 tree.

					- Ted
