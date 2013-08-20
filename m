From: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>
Subject: Re: Which features should I implement in my ext4 reader?
Date: Tue, 20 Aug 2013 12:16:09 +0200
Message-ID: <CACyNnZN4z_mHq86+FPOaGpzjwBVmmsKNjnd45s53o2LdQjxEsg@mail.gmail.com>
References: <CACyNnZNJssSL+UWOXYmWk9xy07WRT_z+Fk9Kjwfws9JRfWoNEQ@mail.gmail.com>
	<CACyNnZManY_k3SB1-p4mQ8Z1+9B=VAdfXU7bWsFVHDsHV6KyUQ@mail.gmail.com>
	<20130817130204.GA30769@thunk.org>
	<CACyNnZONOUy0+OeDriZaSt4OQrR6LzpyJz4Sj8XvMHvxr2u_Xg@mail.gmail.com>
	<20130819050803.GA10882@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Felipe Monteiro de Carvalho <felipemonteiro.carvalho@gmail.com>,
	"Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:40797 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804Ab3HTKQK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 20 Aug 2013 06:16:10 -0400
Received: by mail-pa0-f49.google.com with SMTP id ld10so531120pab.22
        for <linux-ext4@vger.kernel.org>; Tue, 20 Aug 2013 03:16:09 -0700 (PDT)
In-Reply-To: <20130819050803.GA10882@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Aug 19, 2013 at 7:08 AM, Zheng Liu <gnehzuil.liu@gmail.com> wrote:
> You need to checkout to e2fsprogs/pu branch.  All patches for inline data
> are on this branch.  BTW, the latest refinement of patches had been sent
> to the mailing list [1].  It would be great if you could give it a try.
>
> 1. http://comments.gmane.org/gmane.comp.file-systems.ext4/39825

Ok I can try this branch, but I wonder if other tools will work too. I
need also to be able to add some files and directories to the
partition.

Will "mount" from a linux with kernel 3.8 work with a partition
generated with this new e2fsprogs?

-- 
Felipe Monteiro de Carvalho
