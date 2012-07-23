From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCHv7 0/5] ext4: stop using write_supers and s_dirt
Date: Sun, 22 Jul 2012 20:02:02 -0400
Message-ID: <20120723000202.GD9958@thunk.org>
References: <1342014404-14834-1-git-send-email-dedekind1@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>
To: Artem Bityutskiy <dedekind1@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:40576 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536Ab2GWACK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Jul 2012 20:02:10 -0400
Content-Disposition: inline
In-Reply-To: <1342014404-14834-1-git-send-email-dedekind1@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 11, 2012 at 04:46:39PM +0300, Artem Bityutskiy wrote:
> This patch-set makes ext4 file-system stop using the VFS '->write_supers()'
> call-back and the '->s_dirt' superblock field because I plan to remove them
> once all users are gone.

I've applied this patch series, thanks.

							- Ted
