From: Julius Schwartzenberg <julius.schwartzenberg@gmail.com>
Subject: Re: e2fsck doesn't finish
Date: Sun, 23 Apr 2017 16:07:29 +0200
Message-ID: <4eb717f7-1ccb-95a0-0b53-e811651965ee@gmail.com>
References: <f604727f-967c-0b49-a71c-f8adcaeb8945@gmail.com>
 <059b964a-facb-cfd5-6691-4cc1d66fea61@redhat.com>
 <20170418052415.jl44dt2jnmclpx5m@thunk.org>
 <46831715-eb83-51b3-a626-7f6669b02e8a@gmail.com>
 <4A1EA678-9982-4D9D-8559-713487A372B4@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, Eric Sandeen <sandeen@redhat.com>,
        linux-ext4 <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from lb1-smtp-cloud2.xs4all.net ([194.109.24.21]:38397 "EHLO
        lb1-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1045566AbdDWOHd (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 23 Apr 2017 10:07:33 -0400
In-Reply-To: <4A1EA678-9982-4D9D-8559-713487A372B4@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Andreas Dilger wrote:
> It would be useful to know which feature(s) that Fedora 25 enabled that
> Ubuntu 16.04 didn't understand.  You could use something like:
> 
>     dumpe2fs -h /dev/XXX | grep -i feature
> 
> under Ubuntu.  Typically, the code shouldn't be enabling any feature on
> the filesystem without an explicit request from the admin.

I expect that Ubuntu's kernel (4.4.0) supports more features than its
e2fsck as I can mount it now. Ubuntu 16.04 comes with e2fsprogs version
1.42.13. The feature that that version says it doesn't support is
inline_data.


> Also, the "failed to mount" case should print something to the console
> logs about an unsupported feature, which would help isolate the problem.

Yes, it printed it couldn't mount the filesystem as ext3 originally, but
I changed /etc/fstab accordingly.

I have always been quite ignorant on filesystem upgrades and features
supported by either the kernel or e2fsprogs and upgrades/downgrades of
existing filesystems as usually everything just works.
I expect that the upgrade from ext3 to ext4 was triggered by Fedora's
installer (not e2fsprogs) and that dual boot configurations are less
tested in general.

Best regards,
Julius
