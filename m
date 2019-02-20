Return-Path: <SRS0=xo2J=Q3=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADDBDC43381
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 07:57:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 847CC2146E
	for <linux-ext4@archiver.kernel.org>; Wed, 20 Feb 2019 07:57:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725804AbfBTH5i (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 20 Feb 2019 02:57:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60642 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbfBTH5h (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Wed, 20 Feb 2019 02:57:37 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B3CFD80461;
        Wed, 20 Feb 2019 07:57:37 +0000 (UTC)
Received: from localhost (ovpn-117-203.ams2.redhat.com [10.36.117.203])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 592DA600C0;
        Wed, 20 Feb 2019 07:57:37 +0000 (UTC)
Date:   Wed, 20 Feb 2019 07:57:36 +0000
From:   "Richard W.M. Jones" <rjones@redhat.com>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: Create ext2 filesystem from a directory
Message-ID: <20190220075736.GE12500@redhat.com>
References: <20190219080333.GA2912@redhat.com>
 <A7D7D6A2-E789-4175-9ABC-E35774D5DA2F@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A7D7D6A2-E789-4175-9ABC-E35774D5DA2F@dilger.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.28]); Wed, 20 Feb 2019 07:57:37 +0000 (UTC)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Feb 19, 2019 at 10:31:24PM -0800, Andreas Dilger wrote:
> On Feb 19, 2019, at 12:03 AM, Richard W.M. Jones <rjones@redhat.com> wrote:
> > 
> > 
> > This might interest/disgust/shock/scare(?!) people on this list:
> > 
> > $ time ./nbdkit --filter=partition -U - linuxdisk . partition=1 --run 'qemu-img convert $nbd /var/tmp/ext2fs.img'
> > 
> > real   0m1.314s
> > user   0m0.424s
> > sys    0m0.889s
> > 
> > $ ls -lh /var/tmp/ext2fs.img
> > -rw-r--r--. 1 rjones rjones 351M Feb 19 07:44 /var/tmp/ext2fs.img
> > 
> > Code here:
> > 
> > https://github.com/rwmjones/nbdkit/commit/6e7908c828e60f082d84d866070fe8406e6f2b04
> 
> How does this compare to "mke2fs -d <source_dir>"?

Wow, good question.  I was completely unaware of this option until
now, but it'll make the implementation massively simpler.  (We still
need the linuxdisk plugin.)

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-df lists disk usage of guests without needing to install any
software inside the virtual machine.  Supports Linux and Windows.
http://people.redhat.com/~rjones/virt-df/
