From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/4] ext3: trivial quota cleanup
Date: Tue, 2 Feb 2010 14:45:13 +0100
Message-ID: <20100202134508.GB7056@quack.suse.cz>
References: <1265115954-2616-1-git-send-email-dmonakhov@openvz.org>
 <1265115954-2616-2-git-send-email-dmonakhov@openvz.org>
 <1265115954-2616-3-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53229 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab0BBNpF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 2 Feb 2010 08:45:05 -0500
Content-Disposition: inline
In-Reply-To: <1265115954-2616-3-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 02-02-10 16:05:53, Dmitry Monakhov wrote:
> The patch is aimed to reorganize and simplify quota code a bit.
> Quota code is itself complex enouth, but we can make it more readable
> in some places:
> - Move quota option parsing to separate functions.
> - Simplify old-quota and journaled-quota mix check.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
  And this one is good as well. Merged.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
