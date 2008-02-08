From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: [PATCH 0/3] Move fsck from e2fsprogs to util-linux-ng
Date: Fri, 8 Feb 2008 12:16:35 +0100
Message-ID: <3ae72650802080316r6504cea5n43a19da8f83a9642@mail.gmail.com>
References: <20080206113426.7833.59505.stgit@sor.suse.de>
	 <20080206125651.GD558@petra.dvoda.cz> <20080206140559.GJ27119@mit.edu>
	 <3ae72650802061637t2185aaddt8a921c2fb3e8c097@mail.gmail.com>
	 <20080207134105.GU27119@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: "Karel Zak" <kzak@redhat.com>, "Matthias Koenig" <mkoenig@suse.de>,
	util-linux-ng@vger.kernel.org, linux-ext4@vger.kernel.org
To: "Theodore Tso" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:7385 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbYBHLQj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Feb 2008 06:16:39 -0500
Received: by wa-out-1112.google.com with SMTP id v27so381762wah.23
        for <linux-ext4@vger.kernel.org>; Fri, 08 Feb 2008 03:16:36 -0800 (PST)
In-Reply-To: <20080207134105.GU27119@mit.edu>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Feb 7, 2008 2:41 PM, Theodore Tso <tytso@mit.edu> wrote:
> On Thu, Feb 07, 2008 at 01:37:43AM +0100, Kay Sievers wrote:
> >
> > Care to explain what ext4 development has to do with the generic
> > fsck program?  I don''t see any convincing reason not to move that
> > now.
>
> Fsck and mount (and especially mount) needs to be linked against the
> very latest blkid library in order to make sure things work, and when
> we spread out packages across the various different packages, it means
> updating things to assure correct functionality is that much harder.
>
> It also means getting the right ext4 detection routines into vol_id,
> and in the past I've had real problems getting patches that fix real
> bugs in vol_id past you, and I'm just too busy right now to deal with
> that right now.

Sorry, some major distrost don't use blkid at all, so this does not apply
at all to the fact that fsck should not be part of util-linux now. Again provide
facts and stop complaining about the useless probe-reorder patches that
didn't make it into libvolume_id for good reason.

Kay
