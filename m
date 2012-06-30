From: Jeff Liu <jeff.liu@oracle.com>
Subject: [PATCH 1/2] Add a new helper for sleepable BTM acquirements which
 is used by tty_write_message()
Date: Sat, 30 Jun 2012 17:39:58 +0800
Message-ID: <4FEEC96E.9070502@oracle.com>
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

This helper only used by tty_write_message(), it will sleep until BTM lock acquired.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 drivers/tty/tty_mutex.c |   13 +++++++++++++
 include/linux/tty.h     |    1 +
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/tty_mutex.c b/drivers/tty/tty_mutex.c
index 9ff986c..e638636 100644
--- a/drivers/tty/tty_mutex.c
+++ b/drivers/tty/tty_mutex.c
@@ -30,3 +30,16 @@ void __lockfunc tty_unlock(void)
 	mutex_unlock(&big_tty_mutex);
 }
 EXPORT_SYMBOL(tty_unlock);
+
+/*
+ * Wait until getting the big tty mutex.
+ * This function only used by tty_write_message().
+ */
+void __lockfunc tty_lock_wait(void)
+{
+	while (!mutex_trylock(&big_tty_mutex)) {
+		set_current_state(TASK_UNINTERRUPTIBLE);
+		schedule();
+	}
+}
+EXPORT_SYMBOL(tty_lock_wait);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 9f47ab5..5e01e0b 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -607,6 +607,7 @@ extern long vt_compat_ioctl(struct tty_struct *tty,
 /* functions for preparation of BKL removal */
 extern void __lockfunc tty_lock(void) __acquires(tty_lock);
 extern void __lockfunc tty_unlock(void) __releases(tty_lock);
+extern void __lockfunc tty_lock_wait(void) __acquires(tty_lock);
 
 /*
  * this shall be called only from where BTM is held (like close)
-- 
1.7.9
