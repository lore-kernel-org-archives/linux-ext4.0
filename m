From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] configure.in: add --disable-libuuid option (Was: libuuid
	(Re: blkid: util-linux-ng vs. e2fsprogs))
Date: Tue, 30 Jun 2009 12:17:02 +0200
Message-ID: <ac3eb2510906300317q3997f283p80248e44b0c5133d@mail.gmail.com>
References: <200905311113.23004.arvidjaar@mail.ru> <20090601124857.GF31943@mit.edu>
	<20090603085140.GA4060@nb.net.home> <1244021945.4120.4.camel@quest>
	<20090628133430.GA3594@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Scott James Remnant <scott@ubuntu.com>,
	Karel Zak <kzak@redhat.com>,
	Andrey Borzenkov <arvidjaar@mail.ru>,
	util-linux-ng@vger.kernel.org, linux-ext4@vger.kernel.org
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:61092 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbZF3KRV (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 30 Jun 2009 06:17:21 -0400
In-Reply-To: <20090628133430.GA3594@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jun 28, 2009 at 15:34, Theodore Tso<tytso@mit.edu> wrote:

> I'll have a corrected patch checked into e2fsprogs.

Very nice. Thanks!

It seems, that /usr/bin/uuidgen is installed, even when:
  --disable-libblkid
  --disable-libuuid
  --disable-uuidd
is given.


And another thing is your custom "silent build" which can not be
disabled. Our build system requires the command output for fancy
analysis, so it would be good if it could be disabled, like it can for
the kernel (V=1). Any ideas, or do I miss some switch?

Thanks,
Kay
