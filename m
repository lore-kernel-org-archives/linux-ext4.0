Return-Path: <SRS0=xo2J=Q3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4432C43381
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 00:55:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A3402147A
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 00:55:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729671AbfBTAzR (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 19 Feb 2019 19:55:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57740 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727035AbfBTAzQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Tue, 19 Feb 2019 19:55:16 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8994CC059B8C;
        Wed, 20 Feb 2019 00:55:16 +0000 (UTC)
Received: from localhost (ovpn-117-203.ams2.redhat.com [10.36.117.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2D17B66084;
        Wed, 20 Feb 2019 00:55:15 +0000 (UTC)
Date:   Wed, 20 Feb 2019 00:55:15 +0000
From:   "Richard W.M. Jones" <rjones@redhat.com>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: Create ext2 filesystem from a directory
Message-ID: <20190220005515.GD12500@redhat.com>
References: <20190219080333.GA2912@redhat.com>
 <20190220004416.GA31238@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190220004416.GA31238@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 20 Feb 2019 00:55:16 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Feb 19, 2019 at 07:44:16PM -0500, Theodore Y. Ts'o wrote:
> On Tue, Feb 19, 2019 at 08:03:33AM +0000, Richard W.M. Jones wrote:
> > 
> > This might interest/disgust/shock/scare(?!) people on this list:
> > 
> > $ time ./nbdkit --filter=partition -U - linuxdisk . partition=1 --run 'qemu-img convert $nbd /var/tmp/ext2fs.img'
> > 
> 
> For those of us who aren't really familiar with nbdkit, what does this do?

There's quite a lot packed into a small space ...

Firstly nbdkit is an NBD server which is unique in having plugins to
implement different data sources.  In this case I have written a
plugin called "linuxdisk" which creates a GPT-partitioned
ext2-formatted disk image from a local directory ("." in this case).

nbdkit can serve over IP or Unix domain sockets, including randomly
created Unix domain sockets ("-U -").

nbdkit can also run other commands and exit when those commands have
finished (we call this "captive nbdkit").  In this case we ask nbdkit
to run a qemu-img command and then exit when qemu-img finishes.

"qemu-img convert $nbd /var/tmp/ext2fs.img" connects to the private
Unix domain socket (nbdkit sets $nbd to a suitable string to make this
happen).  It then copies the data out of that NBD socket to a local
file, optionally doing a format conversion although not in this case.

Finally nbdkit has a concept of filters which can be placed on top of
plugins to select parts of the data.  Remember that the "linuxdisk"
plugin creates GPT-partitioned ext2 disk images.  However we want only
the naked filesystem.  Therefore we place the partition filter on top
to pick out and serve only the partition content, which is the naked
ext2 filesystem.

I recently did a talk about nbdkit if you want to find out more:
https://rwmj.wordpress.com/2019/02/04/video-take-your-loop-mounts-to-the-next-level-with-nbdkit/

Here's another fun thing you can do with the linuxdisk plugin:
https://rwmj.wordpress.com/2019/02/19/nbdkit-linuxdisk-plugin/

Hope that helps!

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-top is 'top' for virtual machines.  Tiny program with many
powerful monitoring features, net stats, disk stats, logging, etc.
http://people.redhat.com/~rjones/virt-top
