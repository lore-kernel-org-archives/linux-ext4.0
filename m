From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [RESEND][PATCH 2/2 v2] ext4: let us fully support punching hole
 feature in fallocate
Date: Mon, 28 Jan 2013 13:16:35 +0800
Message-ID: <20130128051635.GA12253@gmail.com>
References: <1358493381-20150-1-git-send-email-wenqing.lz@taobao.com>
 <1358493381-20150-2-git-send-email-wenqing.lz@taobao.com>
 <20130125033201.GD28908@thunk.org>
 <20130128050442.GA12217@gmail.com>
 <20130128045713.GA13680@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Zheng Liu <wenqing.lz@taobao.com>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:32777 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938Ab3A1FCe (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 28 Jan 2013 00:02:34 -0500
Received: by mail-da0-f47.google.com with SMTP id s35so1059628dak.6
        for <linux-ext4@vger.kernel.org>; Sun, 27 Jan 2013 21:02:34 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20130128045713.GA13680@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 27, 2013 at 11:57:13PM -0500, Theodore Ts'o wrote:
> On Mon, Jan 28, 2013 at 01:04:42PM +0800, Zheng Liu wrote:
> > 
> > Sorry, my apology.  I found a bug in indirect-based hole punching patch
> > when I tried to create a new test case in xfstest.  A patch has been
> > sent out.  Please look at it.
> 
> Ah yes, this must be the patch found at:
> 
>    http://patchwork.ozlabs.org/patch/216105/


Yes, it is.

> 
> It would it make sense for me to fold this into the punch hole patch,
> yes?  (Since I haven't pushed out the patch yet, I might as well just
> fold in the bugfix into the feature patch.)

No problem.

Thanks,
                                                - Zheng
