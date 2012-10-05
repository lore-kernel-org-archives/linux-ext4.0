From: Prashant Shah <pshah.mumbai@gmail.com>
Subject: freeze_bdev hangs
Date: Fri, 5 Oct 2012 17:28:50 +0530
Message-ID: <CAD6i1f+fzh-z+Xr6V2gHBzq4kmJzPcfre91g=q6fJ7P_5nY0Zw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:60133 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932193Ab2JEL7M (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 5 Oct 2012 07:59:12 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so1226911eek.19
        for <linux-ext4@vger.kernel.org>; Fri, 05 Oct 2012 04:59:11 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

I am writing a filter driver for ext3 in which it replaces the block
device request queue 'make_request_fn' with the driver custom
function. Calling freeze_bdev() or freeze_super() before replacing the
'make_request_fn' hangs the kernel. What am I doing wrong ? Will this
method work ?

full code : https://gist.github.com/3839380

Snippet :

        sb = freeze_bdev(bd);
        if (sb)
                printk(KERN_INFO "filter: freez block device\n");

        if (bd->bd_disk->queue->make_request_fn == filter_mrqfn) {
                printk(KERN_INFO "filter: modules request function is
already active\n");
        } else {
                orig_mrqfn = bd->bd_disk->queue->make_request_fn;
                bd->bd_disk->queue->make_request_fn = filter_mrqfn;
        }
        thaw_bdev(bd, sb);

Please forgive my ignorance, I am a fresher in file systems :)

Regards.
