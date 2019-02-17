Return-Path: <SRS0=V5lK=QY=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E0B8C43381
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Feb 2019 20:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C3832173C
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Feb 2019 20:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550436025;
	bh=DSocnF1L6eyWNj3hPIODBxXx1gHkBTOmUqDASHhUTlI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=KDNuYf8WFkeYfUo1GAOMbE6F9o21vtO81AGDH6sDyzwwRRX1+JPMUTIVsB7sUQFI+
	 /HnIgH4h0eCfNCGcIHxmm/VUDr+iGzqr5/fvW7AXTw2uKeaKr6AQsG/P+Ci1OBNLnd
	 xeEDWebIkiCdRQhe0k/UmqJrJElaEVu/7K4kduPA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726235AbfBQUkZ (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 17 Feb 2019 15:40:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:60108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbfBQUkY (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Sun, 17 Feb 2019 15:40:24 -0500
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1267D218B0
        for <linux-ext4@vger.kernel.org>; Sun, 17 Feb 2019 20:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550436023;
        bh=DSocnF1L6eyWNj3hPIODBxXx1gHkBTOmUqDASHhUTlI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=LuJBlvNvd3qm+c8CSavQDSYtrCzMqVlzd++BRkdjsFhLyda7remWJV3gEJ6d2L2HJ
         bwJpDooZ5Xn20DBpEztsIXVRW51K1lYsCB6tixgYF5u3T0nV7BGh5pG1cFGwXfMjO9
         k3cXzbEC7inGWMh6afmETu+M9EChLD66+qYHpPu4=
Received: by mail-wr1-f45.google.com with SMTP id c8so16081610wrs.4
        for <linux-ext4@vger.kernel.org>; Sun, 17 Feb 2019 12:40:22 -0800 (PST)
X-Gm-Message-State: AHQUAuZZa8hU8o6+sQITrr2kbSGoslXgQhNxLTZs2um5mmpqPXnn/6F0
        qPbE1vwSBjeMddYgWG0bP2l2jmpntD+d8cUOBo8LFg==
X-Google-Smtp-Source: AHgI3Ibg57IFwXe//4IvXlOFrImVvDpNG51+kGQ0Cj4rjhUyaI6txLLa//dLfQr2ZKaR86QZMejnx7SDRhCnf/xAELI=
X-Received: by 2002:adf:eb4c:: with SMTP id u12mr13616557wrn.199.1550436021371;
 Sun, 17 Feb 2019 12:40:21 -0800 (PST)
MIME-Version: 1.0
References: <cover.1550136164.git.osandov@fb.com> <20190214220626.GV14116@dastard>
 <6a9dc05a-0445-d0ab-0140-1de4fee7ba9b@gmail.com> <20190217175450.psaesabv3vlzvjv4@angband.pl>
In-Reply-To: <20190217175450.psaesabv3vlzvjv4@angband.pl>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Sun, 17 Feb 2019 12:40:09 -0800
X-Gmail-Original-Message-ID: <CALCETrWsCUTSbvwemKHB=8=pO4fwK2qD0boFEd4puBDkpb3F9g@mail.gmail.com>
Message-ID: <CALCETrWsCUTSbvwemKHB=8=pO4fwK2qD0boFEd4puBDkpb3F9g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] Allow setting file birth time with utimensat()
To:     Adam Borowski <kilobyte@angband.pl>
Cc:     Boaz Harrosh <openosd@gmail.com>,
        Dave Chinner <david@fromorbit.com>,
        Omar Sandoval <osandov@osandov.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        kernel-team <kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>,
        Linux btrfs Developers List <linux-btrfs@vger.kernel.org>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Sun, Feb 17, 2019 at 9:55 AM Adam Borowski <kilobyte@angband.pl> wrote:
>
> On Sun, Feb 17, 2019 at 06:35:25PM +0200, Boaz Harrosh wrote:
> > On 15/02/19 00:06, Dave Chinner wrote:
> > > So you're adding an interface that allows users to change the create
> > > time of files without needing any privileges?
>
> > > Inode create time is forensic metadata in XFS  - information we use
> > > for sequence of event and inode lifetime analysis during examination
> > > of broken filesystem images and systems that have been broken into.
>
> > I think the difference in opinion here is that there are two totally
> > different BTIme out in the world. For two somewhat opposite motivations
> > and it seems they both try to be crammed into the same on disk space.
> >
> > One - Author creation time
> > Two - Local creation time
>
> > So it looks like both sides are correct trying to preserve their own guy?
>
> I'd say that [2] is too easily gameable to be worth the effort.  You can
> just change it on the disk.  That right now it'd take some skill to find the
> right place to edit doesn't matter -- a tool to update the btime against
> your wishes would need to be written just once.  Unlike btrfs, XFS doesn't
> even have a chain of checksums all the way to the root.
>
> On the other hand, [1] has a lot of uses.  It can also be preserved in
> backups and version control (svnt and git-restore-mtime could be easily
> extended).
>
> I'd thus go with [2] -- any uses for [1] are better delegated to filesystem
> specific tools.
>

I started out in the Windows world, and I found it quite handy to
right-click a file and see when it was created.  When I started using
Linux, I saw things like this:

Access: 2019-02-16 22:19:32.024284060 -0800
Modify: 2016-02-02 19:26:47.901766778 -0800
Change: 2016-02-02 19:26:47.907766649 -0800

and my mind boggled a bit.  Modify makes sense.  Change?  What's that?
 Why do I care?

Adding "birth" makes sense, and I think that filesystem-agnostic
backup tools *should* be able to write it.

So I'm highly in favor of this patch.  If XFS wants to disallow
writing the birth time, fine, but I think that behavior should be
overridable.
