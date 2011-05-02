From: Johann Lombardi <johann@whamcloud.com>
Subject: Re: [PATCH] ext4: add support for multiple mount protection
Date: Mon, 2 May 2011 15:43:38 +0200
Message-ID: <20110502134338.GB14743@granier.hd.free.fr>
References: <1302631493-9778-1-git-send-email-johann@whamcloud.com>
 <4DA4A5E3.4080803@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Andreas Dilger <adilger@whamcloud.com>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64441 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab1EBNnl (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 2 May 2011 09:43:41 -0400
Received: by wwa36 with SMTP id 36so6349431wwa.1
        for <linux-ext4@vger.kernel.org>; Mon, 02 May 2011 06:43:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4DA4A5E3.4080803@itwm.fraunhofer.de>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Bernd,

On Tue, Apr 12, 2011 at 09:20:03PM +0200, Bernd Schubert wrote:
> >+#define EXT4_MMP_UPDATE_INTERVAL   1
> 
> this define is nowhere used (e2fsprogs already sets the
> update-interval in the superblock).

Indeed, i have removed it.

> And it is also too small, which may cause a huge performance issue
> (please remember my corresponding lustre bugzilla...).

The patches i have just sent increase the update interval to 5s and decrease the multiplier used to compute the check interval from 5 to 2.

> Once you are going to post the e2fsprogs patch, could you please
> also take care of the 2TiB mmp-block read limitation bug (please see
> another Lustre bugzilla )?

The updated e2fsprogs & kernel patches use blk64_t/ext4_fsblk_t, so this should work now. I will give this a try ASAP.

> It also would be nice to explain somewhere (and not hidden in the
> code) what is the difference between "update interval" and "check
> interval".

Done.

Thanks for the feedback.

Cheers,
Johann
