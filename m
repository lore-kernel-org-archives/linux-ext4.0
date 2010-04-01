From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] ext4: optimize quota write locking
Date: Thu, 1 Apr 2010 11:14:14 +0200
Message-ID: <20100401091414.GF3322@quack.suse.cz>
References: <1269692140-5375-1-git-send-email-dmonakhov@openvz.org>
 <1269692140-5375-2-git-send-email-dmonakhov@openvz.org>
 <1269692140-5375-3-git-send-email-dmonakhov@openvz.org>
 <1269692140-5375-4-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39712 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754145Ab0DAJOE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 1 Apr 2010 05:14:04 -0400
Content-Disposition: inline
In-Reply-To: <1269692140-5375-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat 27-03-10 15:15:40, Dmitry Monakhov wrote:
> Quota inode is append only. In most cases writes performed
> to allocated blocks before i_size. Currently we grup i_mutex
> for each quota write to protect i_size and i_mtime. But in most
> cases i_size not changed. And i_mtime is not that important
> as for regular files. So let's update it only when quota file
> increased. This allow us to avoid i_mutex in most cases.
  But this won't help performance at all because dqio_mutex serializes
writes to the file already, right?

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
