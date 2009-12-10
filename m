From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: quota macros cleanup
Date: Thu, 10 Dec 2009 16:48:59 +0100
Message-ID: <20091210154859.GC26516@atrey.karlin.mff.cuni.cz>
References: <1260254781-18041-1-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56288 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760830AbZLJPsx (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Dec 2009 10:48:53 -0500
Content-Disposition: inline
In-Reply-To: <1260254781-18041-1-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Currently all quota block reservation macros contains hardcoded "2"
> aka MAXQUOTAS value. This is no good because in some places it is not
> obvious to understand what does this digit represent. Let's introduce
> new macro with self descriptive name.
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
  Nice cleanup. Queued to my tree. Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
