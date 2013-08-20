From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: Which features should I implement in my ext4 reader?
Date: Tue, 20 Aug 2013 18:39:56 +0800
Message-ID: <20130820103956.GA7846@gmail.com>
References: <CACyNnZNJssSL+UWOXYmWk9xy07WRT_z+Fk9Kjwfws9JRfWoNEQ@mail.gmail.com>
 <CACyNnZManY_k3SB1-p4mQ8Z1+9B=VAdfXU7bWsFVHDsHV6KyUQ@mail.gmail.com>
 <20130817130204.GA30769@thunk.org>
 <CACyNnZONOUy0+OeDriZaSt4OQrR6LzpyJz4Sj8XvMHvxr2u_Xg@mail.gmail.com>
 <20130819050803.GA10882@gmail.com>
 <CACyNnZN4z_mHq86+FPOaGpzjwBVmmsKNjnd45s53o2LdQjxEsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40634 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976Ab3HTKjM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Aug 2013 06:39:12 -0400
Received: by mail-pa0-f49.google.com with SMTP id ld10so552874pab.22
        for <linux-ext4@vger.kernel.org>; Tue, 20 Aug 2013 03:39:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CACyNnZN4z_mHq86+FPOaGpzjwBVmmsKNjnd45s53o2LdQjxEsg@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 20, 2013 at 12:16:09PM +0200, Felipe Monteiro de Carvalho wrote:
> On Mon, Aug 19, 2013 at 7:08 AM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> > You need to checkout to e2fsprogs/pu branch.  All patches for inline data
> > are on this branch.  BTW, the latest refinement of patches had been sent
> > to the mailing list [1].  It would be great if you could give it a try.
> >
> > 1. http://comments.gmane.org/gmane.comp.file-systems.ext4/39825
> 
> Ok I can try this branch, but I wonder if other tools will work too. I
> need also to be able to add some files and directories to the
> partition.

I add some new interfaces in libext2fs to manipulate a file system
with inline data feature.  You can use libext2fs to add some files and
directories.  But these interfaces might be changed because it isn't
exported as an ABI.  After it is released within a new e2fsprogs
version, they will never be changed.

> 
> Will "mount" from a linux with kernel 3.8 work with a partition
> generated with this new e2fsprogs?

Yes, you can mount a file system with inline data in a 3.8 kernel using
this branch.

Regards,
                                                - Zheng
