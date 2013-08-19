From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Which features should I implement in my ext4 reader?
Date: Mon, 19 Aug 2013 13:08:04 +0800
Message-ID: <20130819050803.GA10882@gmail.com>
References: <CACyNnZNJssSL+UWOXYmWk9xy07WRT_z+Fk9Kjwfws9JRfWoNEQ@mail.gmail.com>
 <CACyNnZManY_k3SB1-p4mQ8Z1+9B=VAdfXU7bWsFVHDsHV6KyUQ@mail.gmail.com>
 <20130817130204.GA30769@thunk.org>
 <CACyNnZONOUy0+OeDriZaSt4OQrR6LzpyJz4Sj8XvMHvxr2u_Xg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:43189 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab3HSFHW (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 19 Aug 2013 01:07:22 -0400
Received: by mail-pd0-f178.google.com with SMTP id w10so4631999pde.9
        for <linux-ext4@vger.kernel.org>; Sun, 18 Aug 2013 22:07:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CACyNnZONOUy0+OeDriZaSt4OQrR6LzpyJz4Sj8XvMHvxr2u_Xg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hello,

On Sun, Aug 18, 2013 at 08:04:20AM +0200, Felipe Monteiro de Carvalho wrote:
> On Sat, Aug 17, 2013 at 3:02 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> > I think part of the problem (besids lots of people being busy and on
> > vacation) is it's not clear what your ext4 reader is going to be used
> > for.  As a result it's hard to give advice, not knowing what the
> > requirements are for said reader.
> 
> I think that I formulated my question incorrectly. I did not mean
> "please give me advice over my specific application" this time, but
> rather what I wanted was "please tell me a little about these various
> features and also tell me if they are finished or still work in
> progress, etc". Which is precisely what you answered already, so
> thanks a lot =)
> 
> > These features aren't quite fully supported yet.  The inline data
> > feature is probably closest to be being fully supported, when we
> > release an the next major version of e2fsprogs.
> 
> Just for completeness, which version number will that by?
> 
> So, I understand that currently mkfs.ext4 cannot generate ext4 file
> systems with this feature, correct?

You need to checkout to e2fsprogs/pu branch.  All patches for inline data
are on this branch.  BTW, the latest refinement of patches had been sent
to the mailing list [1].  It would be great if you could give it a try.

1. http://comments.gmane.org/gmane.comp.file-systems.ext4/39825

Regards,
                                                - Zheng

> 
> Is there any other way to generate a file system with this feature
> with a 3.8 kernel which will work?
> 
> Just wondering if I can already start work on this or if I need to wait.
> 
> thanks,
> -- 
> Felipe Monteiro de Carvalho
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
