From: "George Spelvin" <linux@horizon.com>
Subject: Re: debugfs: dump a sparse file as a new sparse file
Date: 1 Jan 2013 16:25:04 -0500
Message-ID: <20130101212504.11364.qmail@science.horizon.com>
References: <20130101205709.GC12554@thunk.org>
Cc: gnehzuil.liu@gmail.com, linux-ext4@vger.kernel.org
To: linux@horizon.com, tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from science.horizon.com ([71.41.210.146]:33909 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751788Ab3AAVZF (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 1 Jan 2013 16:25:05 -0500
In-Reply-To: <20130101205709.GC12554@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> There are people who compile e2fsprogs under Windows (e.g. for FUSE
> for Windows support), and MSVC does not support VLA's or C99 in
> general In general I tend to be very conservative about what compiler
> features are used in e2fsprogs, and I do care about portability beyond
> just Linux systems.

Ah, thank you!  I fully agree that's an important C compiler to
target; I had just erroneously assumed that commercial C compilers
would try to be "check-box feature complete" on such matters.

But apparently Microsoft don't support C99 and have no intention to:
http://herbsutter.com/2012/05/03/reader-qa-what-about-vc-and-c99/
http://visualstudio.uservoice.com/forums/121579-visual-studio/suggestions/2089423-c99-support
http://www.infoq.com/news/2012/05/vs_c99_support/

That's a good enough reason; my only remaining objection is calling it
"a non-standard/non-portable GCC extension".
