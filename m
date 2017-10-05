From: Kees Cook <keescook@chromium.org>
Subject: [PATCH] jbd2: Convert timers to use timer_setup()
Date: Wed, 4 Oct 2017 17:48:46 -0700
Message-ID: <20171005004846.GA23025@beast>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Theodore Ts'o <tytso@mit.edu>, Jan Kara <jack@suse.com>,
        linux-ext4@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
To: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

In preparation for unconditionally passing the struct timer_list pointer to
all timer callbacks, switch to using the new timer_setup() and from_timer()
to pass the timer pointer explicitly.

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Jan Kara <jack@suse.com>
Cc: linux-ext4@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
This requires commit 686fef928bba ("timer: Prepare to change timer
callback argument type") in v4.14-rc3, but should be otherwise
stand-alone.
---
 fs/jbd2/journal.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 7d5ef3bf3f3e..d2a85c9720e9 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -165,11 +165,11 @@ static void jbd2_superblock_csum_set(journal_t *j, journal_superblock_t *sb)
  * Helper function used to manage commit timeouts
  */
 
-static void commit_timeout(unsigned long __data)
+static void commit_timeout(struct timer_list *t)
 {
-	struct task_struct * p = (struct task_struct *) __data;
+	journal_t *journal = from_timer(journal, t, j_commit_timer);
 
-	wake_up_process(p);
+	wake_up_process(journal->j_task);
 }
 
 /*
@@ -197,8 +197,7 @@ static int kjournald2(void *arg)
 	 * Set up an interval timer which can be used to trigger a commit wakeup
 	 * after the commit interval expires
 	 */
-	setup_timer(&journal->j_commit_timer, commit_timeout,
-			(unsigned long)current);
+	timer_setup(&journal->j_commit_timer, commit_timeout, 0);
 
 	set_freezable();
 
-- 
2.7.4


-- 
Kees Cook
Pixel Security
