From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: Unable to randomly boot rootfs (EXT3 or EXT4) from SD: MMC error
 -110 (TIMEDOUT)
Date: Tue, 27 Aug 2013 18:01:43 -0400
Message-ID: <20130827220143.GC9182@thunk.org>
References: <CAL1yNcJZBSSNu4aDmL6n9uu3LkNPCOM-LbUXD2990jkPJYpLoA@mail.gmail.com>
 <CAL1yNc+9pOWLCLfk7WpWvvsLfb01cFCJSi+4mTvnks9VrwoF1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Kevyn-Alexandre =?iso-8859-1?Q?Par=E9?=
	<kevyn.alexandre.pare@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:50137 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212Ab3H0WBp (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 Aug 2013 18:01:45 -0400
Content-Disposition: inline
In-Reply-To: <CAL1yNc+9pOWLCLfk7WpWvvsLfb01cFCJSi+4mTvnks9VrwoF1Q@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Aug 27, 2013 at 05:47:22PM -0400, Kevyn-Alexandre Par=E9 wrote:
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, retrying
> mmcblk0: error -110 sending status command, aborting

This looks like a hardware problem; either with the MMC reader, or the
MMC/SD card.

Can you try swapping out the hardware and see if the problem goes
away?

						- Ted
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
