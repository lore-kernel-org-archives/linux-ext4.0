From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/6] kvm-xfstests: add initrd support
Date: Sat, 20 Aug 2016 18:35:42 -0400
Message-ID: <20160820223542.GB855@thunk.org>
References: <1471553651-9547-1-git-send-email-dmonakhov@openvz.org>
 <1471553651-9547-6-git-send-email-dmonakhov@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:48732 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751427AbcHTWfq (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sat, 20 Aug 2016 18:35:46 -0400
Content-Disposition: inline
In-Reply-To: <1471553651-9547-6-git-send-email-dmonakhov@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 19, 2016 at 12:54:10AM +0400, Dmitry Monakhov wrote:
> Sometimes it is important to run kernel which was build with
> modules, so the only way to do this it to pass initrd parameter.
> 
> Example:
> # Run test on official FC24 kernel
> #wget https://mirror.yandex.ru/fedora/linux/releases/24/Server/x86_64/os/images/pxeboot/initrd.img
> #wget https://mirror.yandex.ru/fedora/linux/releases/24/Server/x86_64/os/images/pxeboot/vmlinuz
> #kvm-xfstests.sh --kernel vmlinuz --initrd initrd.img generic/013
> 
> Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>

OK, applied with some slight modifications so that --initrd is only
accepted for kvm-xfstests.

BTW, I tried using the Fedora 24 kernel, and there's something wonky
with the serial console.  It looks like every other character which is
typed is getting eaten.  I suppose it's good to be able to test with
random distribution kernels with initrds, but there may be weird
compatibility issues with different distro's initrds, so I am a bit
worried that this might be a bit of a support headache in the long
term.

						- Ted
