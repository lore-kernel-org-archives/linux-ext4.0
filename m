Return-Path: <SRS0=KfeM=7V=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B73AC433E0
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Jun 2020 20:21:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02D3320775
	for <linux-ext4@archiver.kernel.org>; Mon,  8 Jun 2020 20:21:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726714AbgFHUVV (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Mon, 8 Jun 2020 16:21:21 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:38525 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726415AbgFHUVU (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Jun 2020 16:21:20 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 058KLG89018690
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 8 Jun 2020 16:21:16 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id E39F54200DD; Mon,  8 Jun 2020 16:21:15 -0400 (EDT)
Date:   Mon, 8 Jun 2020 16:21:15 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Andreas Dilger <adilger.kernel@dilger.ca>,
        Jens Axboe <axboe@kernel.dk>, linux-ext4@vger.kernel.org,
        linux-block@vger.kernel.org
Subject: Re: Linux v5.7.1: Ext4-FS and systemd-journald errors after suspend
 + resume
Message-ID: <20200608202115.GH1347934@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUWuds-wNr+NDVPDaxJ83cmCTPPTZ8qL8U5by2FC1uTHYw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Mon, Jun 08, 2020 at 03:26:40PM +0200, Sedat Dilek wrote:
> Hi,
> 
> for a long time I did not try suspend + resume.
> 
> So, with Linux v5.7.1 I tried it.
> 
> As I upgraded my systemd to version 245.6-1 I suspected this change,
> see my report to Debian/systemd team.
> 
> Second, as I saw read-only filesystem problems in the logs I changed
> in /etc/fstab:
> 
> -UUID=<UUID-of-rootfs> /   ext4 errors=remount-ro 0 1
> +UUID=<UUID-of-rootfs> / ext4 defaults 0 1
>
> That did not help.

If you didn't update Othe fstab in the initramfs, the root file system
may still be being mounted with errors=remount-ro.

You can check the current status of a file system's mount options
using /proc/mounts.  Or if you want the full set of changes, you can
look at the file /proc/fs/ext4/<device>/options.

When was the last kernel version and systemd where suspend/resume
worked for you?  If the things work fine until you do a
suspend/resume, this could be either a hardware issue, a driver issue
in the kernel, or systemd issue.  It's almost certainly not a file
system issue, however.  It's likely that you'll need to do a
disciplined set of debugging, where you find which versions of
software work, and then try figuring out what was the first version of
the kernel and/or/systemd where thigns stop working.

					- Ted
