From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH v2] e2fsprogs: Limit number of reserved gdt blocks on
 small fs
Date: Fri, 24 Apr 2015 16:51:44 -0500
Message-ID: <553ABAF0.2020702@redhat.com>
References: <1427280382-31120-1-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
To: Lukas Czerner <lczerner@redhat.com>, linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58607 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966933AbbDXVvs (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 24 Apr 2015 17:51:48 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t3OLplHs024426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-ext4@vger.kernel.org>; Fri, 24 Apr 2015 17:51:47 -0400
In-Reply-To: <1427280382-31120-1-git-send-email-lczerner@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 3/25/15 5:46 AM, Lukas Czerner wrote:
> Currently we're unable to online resize very small (smaller than 32 MB)
> file systems with 1k block size because there is not enough space in the
> journal to put all the reserved gdt blocks.

So, I'll get to the patch review if I need to, but this all seemed a little
odd; this is a regression, so do we really need to restrict things at mkfs
time?

On the userspace side, things were ok until:

9f6ba88 resize2fs: add support for new in-kernel online resize ioctl

and even with that, on the kernelspace side, things were ok until:

8f7d89f jbd2: transaction reservation support

I guess I'm trying to understand why that jbd2 commit regressed this.
I've not been paying enough attention to ext4 lately.  ;)

I mean, the threshold got chopped in half:

-       if (nblocks > journal->j_max_transaction_buffers) {
+       /*
+        * 1/2 of transaction can be reserved so we can practically handle
+        * only 1/2 of maximum transaction size per operation
+        */
+       if (WARN_ON(blocks > journal->j_max_transaction_buffers / 2)) {
                printk(KERN_ERR "JBD2: %s wants too many credits (%d > %d)\n",
-                      current->comm, nblocks,
-                      journal->j_max_transaction_buffers);
+                      current->comm, blocks,
+                      journal->j_max_transaction_buffers / 2);
                return -ENOSPC;
        }

so it's clear why the behavior changed, I guess, but it feels like I
must be missing something here.

The reproducer, for those playing along at home, is something like:

mkfs.ext4 /dev/sda 20M
mount /dev/sda /mnt/test
resize2fs /dev/sda 200M

-Eric


