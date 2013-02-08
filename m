From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/3] Ext2: remove the overhead check about sb in the
 function ext2_new_blocks
Date: Fri, 8 Feb 2013 12:54:08 +0800
Message-ID: <20130208045407.GB19703@gmail.com>
References: <5112BB97.8040206@gmail.com>
 <20130206065645.GA32665@gmail.com>
 <20130206182931.GB1410@thunk.org>
 <CAP9B-Qk-BQL9goEGfxhHPBAG45Va1joRNP0QBJ5C_AEXhvof=A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
	linux-ext4@vger.kernel.org
To: shilong wang <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f41.google.com ([209.85.220.41]:41673 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759682Ab3BHEjt (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Feb 2013 23:39:49 -0500
Received: by mail-pa0-f41.google.com with SMTP id fb11so1858933pad.0
        for <linux-ext4@vger.kernel.org>; Thu, 07 Feb 2013 20:39:48 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAP9B-Qk-BQL9goEGfxhHPBAG45Va1joRNP0QBJ5C_AEXhvof=A@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 07, 2013 at 11:22:21PM +0800, shilong wang wrote:
> 2013/2/7 Theodore Ts'o <tytso@mit.edu>:
> > On Wed, Feb 06, 2013 at 02:56:46PM +0800, Zheng Liu wrote:
> >>
> >> If you want to re-send a patch series, add [RESEND] in subject, please.
> >> Because it could make us know which is the latest one. :-)
> >
> > Ideally, use RESEND if you haven't changed the patch series since the
> > last time you've sent it.  If you have changed it, please use [PATCH
> > v2], [PATCH v3], etc.
> 
> I get it..
> Thanks, thanks every one  for teaching me so much...
> 
> Now i am trying to do something for ext4 development in my leisure time..
> Since i don't know anything about filesystem before.. i have to study
> about it from minix to ext2..ext3..ext4..btrfs..
> 
> However, it still seems a little hard for me to figure everything out
> just by reading code... So i wonder where i can get
> some papers or articles about the new concept of filesystems.. for
> example extent management or something else for ext4..etc
> Maybe it helps a lot for me...

This link (https://ext4.wiki.kernel.org/index.php/Main_Page) might be
useful for you.

Regards,
                                                - Zheng
