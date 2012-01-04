From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: A stackable filesystem to trace low level filesystem operations
Date: Tue, 3 Jan 2012 20:37:53 -0500
Message-ID: <3A1ED8FD-A587-4948-A604-7651A583B9F6@mit.edu>
References: <CAFFtA8429YabMVLp-f15GXBknK+W2oMpqYkZT42zLFaSJ-RBVA@mail.gmail.com> <20120104000314.GV23662@dastard>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@mit.edu>,
	Sushil Mantri <sushilmantri@gmail.com>,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:56626 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485Ab2ADBh5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 3 Jan 2012 20:37:57 -0500
In-Reply-To: <20120104000314.GV23662@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>


On Jan 3, 2012, at 7:03 PM, Dave Chinner wrote:
> 
> Add your own trace points to the VFS and extract and filter them
> with trace-cmd.

Tracepoints are definitely the way to go, and I'd suggest moving this discussion to the fsdevel@vger.kernel.org mailing list, and see if we can get a set of tracepoints that everyone would find useful and drop them into the VFS as standard tracepoints that people using SystemTap, or perf, or trace, other standardized tracing tools, can use.

Sushil, maybe you can learn about how tracepoints work and drive this effort?

Regards,

-- Ted


