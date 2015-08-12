From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: fsync stuck at jbd2_log_wait_commit on NVMe devices
Date: Wed, 12 Aug 2015 14:37:50 -0400
Message-ID: <20150812183750.GB3373@thunk.org>
References: <COL130-W652BF73D365EBB4F3DDF69D67E0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: Roy Yang <bsdnet@outlook.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:55372 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751137AbbHLShw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 12 Aug 2015 14:37:52 -0400
Content-Disposition: inline
In-Reply-To: <COL130-W652BF73D365EBB4F3DDF69D67E0@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Roy,

My suggestion is to collect information from the jbd2_run_stats and
jbd2_checkpoint_stats tracepoints.

cd /sys/kernel/debug/tracing
echo 1 > events/jbd2/jbd2_run_stats/enable
echo 1 > events/jbd2/jbd2_checkpoint_stats/enable
cat trace_pipe > /tmp/traces &
tail -f /tmp/traces

The jbd2_handle_stats tracepoint can be informative, but it's also far
more voluminous.

That will give us a hint where things are getting bottlenecked.

What sort of workload is your application doing?  Is it just primarily
doing random writes into a preallocated file?  Is it creating or
deleting files?  Extending or truncating files?   etc.

	 	 	      		 - Ted
