From: Julius Schwartzenberg <julius.schwartzenberg@gmail.com>
Subject: Re: e2fsck doesn't finish
Date: Wed, 19 Apr 2017 22:57:00 +0200
Message-ID: <46831715-eb83-51b3-a626-7f6669b02e8a@gmail.com>
References: <f604727f-967c-0b49-a71c-f8adcaeb8945@gmail.com>
 <059b964a-facb-cfd5-6691-4cc1d66fea61@redhat.com>
 <20170418052415.jl44dt2jnmclpx5m@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, sandeen@redhat.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:60176 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S938916AbdDSU5F (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 19 Apr 2017 16:57:05 -0400
In-Reply-To: <20170418052415.jl44dt2jnmclpx5m@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> It looks like the problem is fixed with the latest version of
> e2fsprogs, though.  I just tried running using a build of e2fsprogs
> from the next branch, and this seems to allow e2fsck to fully fix the
> file system and avoid the "aborted" message.

I just tried the latest e2fsck from git and it indeed fully got through.
I'm really glad here and I hope there will be a new release of e2fsprogs
soon!

I still have a (dd) copy of the original full image on my external hard
drive in case it would be useful.

I don't know if this is relevant, but maybe it could also be related to
a conversion? Till recently the filesystem was still ext3 and I was only
using it from Ubuntu 16.04. After installing Fedora 25 on another
partition, Ubuntu couldn't mount this partition anymore and I had to
change its entry in /etc/fstab from ext3 to ext4. Then it could mount
it, but Ubuntu's e2fsck complained there were features in use that it
didn't support. I reported this Fedora bug then:
https://bugzilla.redhat.com/show_bug.cgi?id=1440429

After I reported bug, I ran into the issues with e2fsck failing to complete.

In any case, thanks a lot Theodore and Eric for looking into this! My
issue is solved now, but if there's anything that would still be useful
to figure out I'll be glad to provide any information that could help.

Thanks!
Julius
