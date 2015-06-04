From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [RFC/PATCH 0/8] Introduce strreplace
Date: Thu,  4 Jun 2015 11:37:07 +0200
Message-ID: <1433410636-26812-1-git-send-email-linux@rasmusvillemoes.dk>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	linux-ext4@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Neil Brown <neilb@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Doing single-character substitution on an entire string is open-coded
in a few places, sometimes in a rather suboptimal way. This introduces
a trivial helper, strreplace, for this task along with a few example
conversions.

Rasmus Villemoes (8):
  lib: string: Introduce strreplace
  kernel/trace/trace_events_filter.c: Use strreplace
  blktrace: use strreplace in do_blk_trace_setup
  lib/kobject.c: Use strreplace
  drivers/base/core.c: Use strreplace
  drivers/md/md.c: Use strreplace
  fs/jbd2/journal.c: Use strreplace
  fs/ext4/super.c: Use strreplace in ext4_fill_super

 drivers/base/core.c                |  5 +----
 drivers/md/md.c                    |  4 +---
 fs/ext4/super.c                    |  4 +---
 fs/jbd2/journal.c                  | 10 ++--------
 include/linux/string.h             |  1 +
 kernel/trace/blktrace.c            |  6 ++----
 kernel/trace/trace_events_filter.c |  5 ++---
 lib/kobject.c                      |  4 +---
 lib/string.c                       | 17 +++++++++++++++++
 9 files changed, 28 insertions(+), 28 deletions(-)

-- 
2.1.3
