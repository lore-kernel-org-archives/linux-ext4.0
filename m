From: Jan Kara <jack@suse.cz>
Subject: Re: ext4_da_update_reserve_space warning fix not in stable
Date: Wed, 7 Jan 2015 20:21:05 +0100
Message-ID: <20150107192105.GE2802@quack.suse.cz>
References: <54AD772B.2050003@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, tytso@mit.edu,
	adilger.kernel@dilger.ca, jack@suse.cz
To: Josh Hunt <johunt@akamai.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52774 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbbAGTVL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 7 Jan 2015 14:21:11 -0500
Content-Disposition: inline
In-Reply-To: <54AD772B.2050003@akamai.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed 07-01-15 12:12:59, Josh Hunt wrote:
> We are hitting the following warning in the field pretty frequently
> on the latest 3.10 stable kernel:
> [11708.763067] WARNING: at fs/ext4/inode.c:363
> ext4_da_update_reserve_space+0x261/0x280 [ext4]()
> 
> The issue was resolved via "ext4: fix warning in
> ext4_da_update_reserve_space()" (7d7345322d60ed), but the fix was
> not submitted as a stable update for 3.10. I was wondering if
> there's a reason why this was not done, or if it was just
> overlooked?
> 
> The patch appears to have a dependency on "quota: provide interface
> for readding allocated space into reserved space" (1c8924eb106c1ac),
> so I think both would need to be submitted if you feel it's
> possible.
  Since the problem is relatively harmless, I think we didn't bother
porting it to 3.10. Feel free to port those two patches to 3.10 and submit
them to stable@vger.kernel.org.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
