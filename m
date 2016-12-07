From: Jan Kara <jack@suse.cz>
Subject: Re: patch ext4: fix data exposure after a crash still work ?
Date: Wed, 7 Dec 2016 12:47:32 +0100
Message-ID: <20161207114732.GD8394@quack2.suse.cz>
References: <b9885defb2ad439a92c8a64c73e26dba@SGPMBX1004.APAC.bosch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "HUANG Weller (CM/ESW12-CN)" <Weller.Huang@cn.bosch.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59781 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751515AbcLGLrf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 7 Dec 2016 06:47:35 -0500
Content-Disposition: inline
In-Reply-To: <b9885defb2ad439a92c8a64c73e26dba@SGPMBX1004.APAC.bosch.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi!

On Tue 06-12-16 09:52:01, HUANG Weller (CM/ESW12-CN) wrote:
> Since we move to kernel 3.18 stable branch. i found the patch " ext4: fix data exposure after a crash " not available but I found below commit which mentioned that patch.
> I want to check with you whether " ext4: fix data exposure after a crash " still needed currently ?
> I guess yes but I want to confirm with you.

Yes, it is still needed. Actually, I've already backported the fix to
3.12-based kernel we use for our distribution kernel. Probably I should
push it to official 3.12-stable kernel as well.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
