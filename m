From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: fix incorrect block reservation on quota transfer.
Date: Thu, 10 Dec 2009 16:52:45 +0100
Message-ID: <20091210155245.GD26516@atrey.karlin.mff.cuni.cz>
References: <1260254781-18041-1-git-send-email-dmonakhov@openvz.org> <1260254781-18041-2-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60537 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760890AbZLJPwj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Dec 2009 10:52:39 -0500
Content-Disposition: inline
In-Reply-To: <1260254781-18041-2-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Inside ->setattr() call  both ATTR_UID and ATTR_GID may be valid
> This means that we end-up with transering all quotas. Add we have
> to reserve QUOTA_DEL_BLOCKS for all quotas, as we do in case of
> QUOTA_INIT_BLOCKS.
  Actually, this is a bug introduced by your previous patch (there used
to be a brace after 2*) ;). I've merged this change into your previous
patch.
								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
