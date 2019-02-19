Return-Path: <SRS0=bqz9=Q2=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFBAAC43381
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Feb 2019 08:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C54A721903
	for <linux-ext4@archiver.kernel.org>; Tue, 19 Feb 2019 08:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbfBSIDf (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Feb 2019 03:03:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33198 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725768AbfBSIDf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 19 Feb 2019 03:03:35 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 236131219D0
        for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2019 08:03:35 +0000 (UTC)
Received: from localhost (ovpn-117-203.ams2.redhat.com [10.36.117.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C01A65D6AA
        for <linux-ext4@vger.kernel.org>; Tue, 19 Feb 2019 08:03:34 +0000 (UTC)
Date:   Tue, 19 Feb 2019 08:03:33 +0000
From:   "Richard W.M. Jones" <rjones@redhat.com>
To:     linux-ext4@vger.kernel.org
Subject: Create ext2 filesystem from a directory
Message-ID: <20190219080333.GA2912@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Tue, 19 Feb 2019 08:03:35 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org


This might interest/disgust/shock/scare(?!) people on this list:

$ time ./nbdkit --filter=partition -U - linuxdisk . partition=1 --run 'qemu-img convert $nbd /var/tmp/ext2fs.img'

real   0m1.314s
user   0m0.424s
sys    0m0.889s

$ ls -lh /var/tmp/ext2fs.img 
-rw-r--r--. 1 rjones rjones 351M Feb 19 07:44 /var/tmp/ext2fs.img

Code here:

https://github.com/rwmjones/nbdkit/commit/6e7908c828e60f082d84d866070fe8406e6f2b04

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-p2v converts physical machines to virtual machines.  Boot with a
live CD or over the network (PXE) and turn machines into KVM guests.
http://libguestfs.org/virt-v2v
