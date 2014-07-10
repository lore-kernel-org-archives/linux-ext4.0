From: Azat Khuzhin <a3at.mail@gmail.com>
Subject: Re: [PATCH 4/4 v2] lib: add EXT2_ prefix for SUPERBLOCK_{OFFSET,SIZE}
Date: Thu, 10 Jul 2014 10:00:25 +0400
Message-ID: <20140710060025.GV4622@azat>
References: <20140709195844.GD10417@birch.djwong.org>
 <1404936525-11914-1-git-send-email-a3at.mail@gmail.com>
 <952214F8-A0E2-4F2C-A749-60C3B5E1109B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: darrick.wong@oracle.com, linux-ext4@vger.kernel.org, tytso@mit.edu
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:48053 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaGJGA3 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 10 Jul 2014 02:00:29 -0400
Received: by mail-la0-f42.google.com with SMTP id pn19so5826901lab.29
        for <linux-ext4@vger.kernel.org>; Wed, 09 Jul 2014 23:00:27 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <952214F8-A0E2-4F2C-A749-60C3B5E1109B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Jul 09, 2014 at 02:32:54PM -0600, Andreas Dilger wrote:
> 
> On Jul 9, 2014, at 2:08 PM, Azat Khuzhin <a3at.mail@gmail.com> wrote:
> 
> > Since mostly all macros have this prefix, and to avoid potential name
> > clashes.
> > 
> > Proposed-by: Andreas Dilger <adilger@dilger.ca>
> > Signed-off-by: Azat Khuzhin <a3at.mail@gmail.com>
> 
> You can add:
> 
> Reviewed-by: Andreas Dilger <adilger@dilger.ca>
> 
> If you are refreshing the whole series, it might make sense to move this
> first, instead of adding a bunch of SUPERBLOCK_{SIZE,OFFSET} uses, and
> then changing them to EXT2_SUPERBLOCK_{SIZE,OFFSET} in the next patch.
> Not a huge deal either way, just a suggestion.

Yeah, that's a good point, I will do this.
Thanks.

Cheers, Azat.


-- 
Respectfully
Azat Khuzhin
