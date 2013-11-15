From: Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] ext4: Use trace condition for ext4_mballoc tracepoints
Date: Thu, 14 Nov 2013 23:08:11 -0500
Message-ID: <20131114230811.257ad6cc@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Doing an if statement to test some condition to know if we should
trigger a tracepoint is pointless when tracing is disabled. This just
adds overhead and wastes a branch prediction. This is why the
TRACE_EVENT_CONDITION() was created. It places the check inside the jump
label so that the branch does not happen unless tracing is enabled.

That is, instead of doing:

	if (em)
		trace_btrfs_get_extent(root, em);

Which is basically this:

	if (em)
		if (static_key(trace_btrfs_get_extent)) {


Using a TRACE_EVENT_CONDITION() we can just do:

	trace_btrfs_get_extent(root, em);

And the condition trace event will do:

	if (static_key(trace_btrfs_get_extent)) {
		if (em) {
			...

The static key is a non conditional jump (or nop) that is faster than
having to check if em is NULL or not.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
