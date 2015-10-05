From: Andy Leiserson <andy@leiserson.org>
Subject: Fwd: meta_bg descriptor backup calculation bug
Date: Mon, 5 Oct 2015 09:07:41 -0700
Message-ID: <CAP8U4WbQ=P9UMySzXmpmxBfCNEhJZHH1ES5+GH7az0A5bu+tyw@mail.gmail.com>
References: <CAP8U4WYkO377Ec7YSKAt0otd8Sz2HQWUCd4fKdRZMaoYf8wwCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-ext4@vger.kernel.org
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34446 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348AbbJEQHn (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 5 Oct 2015 12:07:43 -0400
Received: by wicfx3 with SMTP id fx3so127526515wic.1
        for <linux-ext4@vger.kernel.org>; Mon, 05 Oct 2015 09:07:42 -0700 (PDT)
In-Reply-To: <CAP8U4WYkO377Ec7YSKAt0otd8Sz2HQWUCd4fKdRZMaoYf8wwCw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Just sent a patch related to this. Some more background:

I observed this on a 1K block filesystem that I resized from 16 GB to
24 GB. Prior to the resize there were no remaining reserved GDT
blocks.

Possibly related to this issue, or possibly due to unrelated
corruption, the filesystem errored and remounted read only. I rebooted
and fsck'ed and discovered the corruption to be substantial.
Unfortunately I don't have a block-level backup of the original state
of the filesystem, the errors from before the reboot, or a log of what
the initial fsck did. (I don't think that I let it do much, if
anything, more than try to replay the journal, which was not
successful.)

What I found in debugfs was that:
* The descriptor data for groups 0..31 instead described groups 3040..3071.
* The descriptor data for groups 2048..3071 was zero'ed (except checksum)

The first bullet is what gave me the idea that the new descriptors
were being written in the wrong place. But I don't have a solid
explanation for the second bullet.

I tried similar resizes to the original with debugging enabled before
and after my proposed fix, and the "updating metadata backup" messages
are consistent with the explanation. Before the fix, every meta_bg
backup goes to blocks 8194 and 253953. 8194 is a backup copy of the
first descriptor block, explaining why groups 0..31 were overwritten
(assuming fsck tried to use the first backup copy). 253953 contains a
block bitmap, and doing an fsck immediately after the resize finds a
bunch of block bitmap inconsistencies.
