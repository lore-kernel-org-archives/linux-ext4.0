From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/4] ext3: mount flags manipulation cleanup
Date: Tue, 2 Feb 2010 14:44:41 +0100
Message-ID: <20100202134440.GA7056@quack.suse.cz>
References: <1265115954-2616-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53216 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab0BBNof (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Feb 2010 08:44:35 -0500
Content-Disposition: inline
In-Reply-To: <1265115954-2616-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 02-02-10 16:05:51, Dmitry Monakhov wrote:
> Replace intermediate EXT3_MOUNT_XXX flags manipulation to
> corresponding macro.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
  Nice cleanup. Thanks. Merged into my tree...

							Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
