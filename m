From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 4/4] ext4: trivial quota cleanup
Date: Tue, 2 Feb 2010 14:46:04 +0100
Message-ID: <20100202134604.GD7056@quack.suse.cz>
References: <1265115954-2616-1-git-send-email-dmonakhov@openvz.org>
 <1265115954-2616-2-git-send-email-dmonakhov@openvz.org>
 <1265115954-2616-3-git-send-email-dmonakhov@openvz.org>
 <1265115954-2616-4-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53248 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab0BBNpz (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Feb 2010 08:45:55 -0500
Content-Disposition: inline
In-Reply-To: <1265115954-2616-4-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 02-02-10 16:05:54, Dmitry Monakhov wrote:
> The patch is aimed to reorganize and simplify quota code a bit.
> Quota code is itself complex enouth, but we can make it more readable
> in some places:
> - Move quota option parsing to separate functions.
> - Simplify old-quota and journaled-quota mix check.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
  Looks good.

Acked-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
