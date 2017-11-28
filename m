From: "Riccardo S." <sirmy15@gmail.com>
Subject: Re: [PATCH 1/3] fs/ext4: release kobject/kset even when
 init/register fail
Date: Tue, 28 Nov 2017 12:03:39 +0100
Message-ID: <20171128110339.GD83442@rschirone-mbp.local>
References: <20171127231801.27652-1-sirmy15@gmail.com>
 <20171127231801.27652-2-sirmy15@gmail.com>
 <C79E8778-794D-4B40-92EA-65862E290B4B@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>,
        linux-ext4 <linux-ext4@vger.kernel.org>,
        gregkh@linuxfoundation.org
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:40198 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753221AbdK1LDq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 28 Nov 2017 06:03:46 -0500
Received: by mail-wr0-f196.google.com with SMTP id s41so23981598wrc.7
        for <linux-ext4@vger.kernel.org>; Tue, 28 Nov 2017 03:03:46 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <C79E8778-794D-4B40-92EA-65862E290B4B@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 11/27, Andreas Dilger wrote:
> On Nov 27, 2017, at 4:17 PM, Riccardo Schirone <sirmy15@gmail.com> wrote:
> > 
> > Even when kobject_init_and_add/kset_register fail, the kobject has been
> > already initialized and the refcount set to 1. Thus it is necessary to
> > release the kobject/kset, to avoid the memory associated with it hanging
> > around forever.
> 
> This seems like a bad programming model.  It doesn't make sense if the
> "init" or "register" function returns an error that you would still have
> to call "put" or "unregister" on the object.  Why not just handle the
> cleanup at the end of "kobject_init_and_add()" or "kobject_register()"
> if there is an error instead of putting the burden on every caller?
> 
> If open() returns an error, I don't need to call close(), and if malloc()
> fails I don't need to call free(), etc.
> 
> Cheers, Andreas
> 

I agree it seems weird at first, but it looks to me the examples you
made involve the *creation* of new objects, so it makes sense that the
function, in case of errors, does not create them at all.

In this case though the kobject_init_and_add is really just a shortcut
for kobject_init + kobject_add and none of these functions create
something for you. It's the caller's job to allocate the necessary
memory, so I think that's the reason why it's still the caller that
calls kobject_put when there's something wrong.

Instead, in kobject_create_and_add, where the creation of the kobject is
inside the function, the kobject is cleaned up if something wrong
happens.

Those are my thoughts anyway.
Regards,


Riccardo
