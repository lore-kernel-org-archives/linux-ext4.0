From: Jeff Liu <jeff.liu@oracle.com>
Subject: [PATCH 2/2] make both atomic_write_lock and BTM lock acquirement
 sleepable at tty_write_message()
Date: Sat, 30 Jun 2012 17:40:03 +0800
Message-ID: <4FEEC973.4090905@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	gregkh@linuxfoundation.org, Jan Kara <jack@suse.cz>,
	"Ted Ts'o" <tytso@mit.edu>
To: linux-serial@vger.kernel.org
Return-path: <linux-serial-owner@vger.kernel.org>
Sender: linux-serial-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Avoid lockdep warn by having both lock acquirements sleepable.
BTM also have to go to sleep if lock failed at the first time, otherwise it
will race with tty_open()->tty_lock().

Signed-off-by: Jie Liu <jeff.liu@oracle.com>

---
 drivers/tty/tty_io.c |   35 +++++++++++++++++++++++++++++++----
 1 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index b425c79..2b4664d 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1098,12 +1098,40 @@ out:
  *
  * We must still hold the BTM and test the CLOSING flag for the moment.
  */
-
 void tty_write_message(struct tty_struct *tty, char *msg)
 {
+retry:
 	if (tty) {
-		mutex_lock(&tty->atomic_write_lock);
-		tty_lock();
+		/*
+		 * tty_write_message() will invoked by print_warning()
+		 * at fs/quota/dquot.c if CONFIG_PRINT_QUOTA_WARNING
+		 * is enabled when a user running out of disk quota limits.
+		 * It will end up call tty_write().  Here is a potential race
+		 * situation since tty_write() call copy_from_user() which
+		 * might produce page faults and turn to invoke inodes dirty
+		 * process on the underlying file systems if needed, and
+		 * it will try to acquire JBD/JBD2 lock accordingly.  This
+		 * might make lockdep unhappy to print dead lock warning.
+		 * To solve this issue, we have to go to sleep and relinquish
+		 * the CPU power to another process until the atomic_write_lock
+		 * became available.
+		 */
+		if (!mutex_trylock(&tty->atomic_write_lock)) {
+			DEFINE_WAIT(wait);
+			prepare_to_wait_exclusive(&tty->write_wait, &wait,
+						  TASK_INTERRUPTIBLE);
+			schedule();
+			finish_wait(&tty->write_wait, &wait);
+			goto retry;
+		}
+
+		/*
+		 * Call tty_lock() directly might race with tty_open() even
+		 * if we have already got the atomic_write_lock. However, we
+		 * must perform TTY_CLOSING check up with the BTM hold, so call
+		 * tty_lock_wait() which is sleepable instead.
+		 */
+		tty_lock_wait();
 		if (tty->ops->write && !test_bit(TTY_CLOSING, &tty->flags)) {
 			tty_unlock();
 			tty->ops->write(tty, msg, strlen(msg));
@@ -1114,7 +1142,6 @@ void tty_write_message(struct tty_struct *tty, char *msg)
 	return;
 }
 
-
 /**
  *	tty_write		-	write method for tty device file
  *	@file: tty file pointer
-- 
1.7.9
