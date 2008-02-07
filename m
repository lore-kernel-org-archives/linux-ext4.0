From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 0/3] Move fsck from e2fsprogs to util-linux-ng
Date: Thu, 7 Feb 2008 08:41:05 -0500
Message-ID: <20080207134105.GU27119@mit.edu>
References: <20080206113426.7833.59505.stgit@sor.suse.de> <20080206125651.GD558@petra.dvoda.cz> <20080206140559.GJ27119@mit.edu> <3ae72650802061637t2185aaddt8a921c2fb3e8c097@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Karel Zak <kzak@redhat.com>, Matthias Koenig <mkoenig@suse.de>,
	util-linux-ng@vger.kernel.org, linux-ext4@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:59822 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753192AbYBGNl7 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Feb 2008 08:41:59 -0500
Content-Disposition: inline
In-Reply-To: <3ae72650802061637t2185aaddt8a921c2fb3e8c097@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Feb 07, 2008 at 01:37:43AM +0100, Kay Sievers wrote:
> 
> Care to explain what ext4 development has to do with the generic
> fsck program?  I don''t see any convincing reason not to move that
> now.

Fsck and mount (and especially mount) needs to be linked against the
very latest blkid library in order to make sure things work, and when
we spread out packages across the various different packages, it means
updating things to assure correct functionality is that much harder.

It also means getting the right ext4 detection routines into vol_id,
and in the past I've had real problems getting patches that fix real
bugs in vol_id past you, and I'm just too busy right now to deal with
that right now.

						- Ted
