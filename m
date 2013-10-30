From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: drop unsed reclen variable from
 ext4_add_dirent_to_inline()
Date: Wed, 30 Oct 2013 10:55:23 -0400
Message-ID: <20131030145523.GD3305@thunk.org>
References: <1379535450-31253-1-git-send-email-a3at.mail@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	"open list:EXT4 FILE SYSTEM" <linux-ext4@vger.kernel.org>
To: Azat Khuzhin <a3at.mail@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:52498 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab3J3Qu7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 30 Oct 2013 12:50:59 -0400
Content-Disposition: inline
In-Reply-To: <1379535450-31253-1-git-send-email-a3at.mail@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Sep 19, 2013 at 12:17:30AM +0400, Azat Khuzhin wrote:
> Functions that need in it, already calculate reclen from namelen by
> themselves:
> - ext4_find_dest_de()
> - ext4_insert_dentry()
> 
> Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>

Applied, thanks.

					- Ted
