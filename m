From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH 1/1] ext4: Remove duplicate inclusion of ext4_extents.h
 in super.c
Date: Tue, 20 Nov 2012 00:22:11 +0800
Message-ID: <20121119162211.GA2337@gmail.com>
References: <1353323842-32283-1-git-send-email-sachin.kamat@linaro.org>
 <20121119133944.GA11095@gmail.com>
 <20121119150000.GA29807@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Sachin Kamat <sachin.kamat@linaro.org>, linux-ext4@vger.kernel.org,
	adilger.kernel@dilger.ca, patches@linaro.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51519 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab2KSQJi (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Nov 2012 11:09:38 -0500
Received: by mail-pb0-f46.google.com with SMTP id wy7so3562935pbc.19
        for <linux-ext4@vger.kernel.org>; Mon, 19 Nov 2012 08:09:38 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20121119150000.GA29807@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 19, 2012 at 10:00:00AM -0500, Theodore Ts'o wrote:
> On Mon, Nov 19, 2012 at 09:39:45PM +0800, Zheng Liu wrote:
> > Hi Sachin,
> > 
> > Sorry, I don't find this duplicated code in mainline kernel 3.7-rc6.
> 
> It's there because ext4.h includes ext4_extents.h -- at the end of the
> header file, where it's not quite as obvious.

Ah, I see.  Thanks for pointing out.

> 
> What we should probably do is move the function declarations into
> ext4.h, and then see if we can isolate the number of fs/ext4/*.c files
> that are aware of the on-disk extents encoding, such that it doesn't
> make sense to #include ext4_extenst.h from the ext4.h header file.
> 
> It's mainly a cleanup thing, but it would probably also help if we
> ever want to support alternate extents encodings (for example to
> support a full 64-bit physical block numbers, or more likely, more
> than 32 bits worth of logical block nunbers --- so we can test large
> file systems natively using ext4, instead of using xfs, which is what
> I currently do).  That's a low priority thing in my book, but if
> someone is interesting in taking on the project, they should let me
> know.

Cool!  Thanks for sharing this information with us.

Regards,
                                                - Zheng
