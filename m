From: Jan Kara <jack@suse.cz>
Subject: Re: INFO: task umount:1524 blocked for more than 120 seconds
Date: Wed, 12 May 2010 17:04:04 +0200
Message-ID: <20100512150404.GB29867@atrey.karlin.mff.cuni.cz>
References: <h2xdd18b0c31005101446pf8201153vaed5b38afe72d7ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Justin Mattock <justinmattock@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ksp.mff.cuni.cz ([195.113.26.206]:56830 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751299Ab0ELPEF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 May 2010 11:04:05 -0400
Content-Disposition: inline
In-Reply-To: <h2xdd18b0c31005101446pf8201153vaed5b38afe72d7ad@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> I have a reproduceable problem  happening over here
> with unmount and ext4
> if I sudo cp -R xserver(all libs/apps from git)
> to an external
> SmartDsk FireLite
> then after the cp is done
> sudo umount /dev/sdb1
> 
> I get this:
> 
>  type=1400 audit(1273526248.814:27): avc:  denied  { unmount } for
> pid=1524 comm="umount" scontext=justin:staff_r:staff_sudo_t:s0
> tcontext=system_u:object_r:fs_t:s0 tclass=filesystem
> [  360.669140] INFO: task umount:1524 blocked for more than 120 seconds.
  I guess your are hitting a variant of
https://bugzilla.kernel.org/show_bug.cgi?id=15906
  Does the fix there make things better for you?

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
