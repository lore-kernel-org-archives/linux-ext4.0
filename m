From: Kevin Liao <kevinliao@qnap.com>
Subject: Re: [PATCH] ext4: Only call update_backups if necessary in online resize.
Date: Wed, 26 Sep 2012 13:26:14 +0800
Message-ID: <CAOoaTqUvBbJnKRcxe6RTL8fw1Q76B7Dtqqa3T37X2qgOk4ugTQ@mail.gmail.com>
References: <1348498817-3598-1-git-send-email-tm@tao.ma>
	<20120926033935.GD11468@thunk.org>
	<50627BA5.60106@tao.ma>
	<20120926040349.GG11468@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Tao Ma <tm@tao.ma>, linux-ext4@vger.kernel.org
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56287 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2IZF0P (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Sep 2012 01:26:15 -0400
Received: by pbbrr4 with SMTP id rr4so1307235pbb.19
        for <linux-ext4@vger.kernel.org>; Tue, 25 Sep 2012 22:26:15 -0700 (PDT)
In-Reply-To: <20120926040349.GG11468@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2012/9/26 Theodore Ts'o <tytso@mit.edu>
>
> On Wed, Sep 26, 2012 at 11:51:01AM +0800, Tao Ma wrote:
> > Why?  If it isn't the same as the previous one, it will be updated. If
> > it is the same, it don't need to be updated. I don't see what your mean
> > here.
>
> Oh, I see; sorry, I was just looking at the patch and not the file
> with the changes in context.  I thought you were updating the backup
> descriptors after modifying the last block group in the meta_bg group,
> but that was my confusion.
>
> Yes, your patch looks good and I will apply it, thanks!!
>
>                                       - Ted

Hi Ted,

Is this patch should be merged with your previous patches about meta_bg
online resize on 9/14?

[PATCH 2/9] avoid duplicate writes of the backup bg descriptor blocks
[PATCH 5/9] add online resizing support for meta_bg and 64-bit file systems

Regards,
Kevin Liao
