From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: [PATCH] jbd: wait for already submitted t_sync_datalist buffer
  to complete
Date: Wed, 29 Nov 2006 17:21:17 +0900
Message-ID: <6.0.0.20.2.20061128183152.036beb20@172.19.0.2>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
To: akpm@osdl.org, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Hi.

In the current jbd code, if a buffer on BJ_SyncData list is dirty and not 
locked,
the buffer is refiled to BJ_Locked list, submitted to the IO and waited for 
IO completion.
But the fsstress test showed the case that when a buffer was already submitted
to the IO just before the buffer_dirty(bh) check, the buffer was not waited 
for IO
completion.

Following patch solves this problem. If it is assumed that a buffer is 
submitted to the IO
before the buffer_dirty(bh) check and still being written to disk, this 
buffer is refiled to
BJ_Locked list.

Thanks.

Signed-off-by :Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>

--- linux-2.6.19-rc6.org/fs/jbd/commit.c	2006-11-28 17:10:01.000000000 +0900
+++ linux-2.6.19-rc6/fs/jbd/commit.c	2006-11-29 14:51:09.000000000 +0900
@@ -248,8 +248,12 @@ write_out_data:
  				bufs = 0;
  				goto write_out_data;
  			}
-		}
-		else {
+		} else if (!locked && buffer_locked(bh)) {
+			__journal_file_buffer(jh, commit_transaction,
+						BJ_Locked);
+			jbd_unlock_bh_state(bh);
+			put_bh(bh);
+		} else {
  			BUFFER_TRACE(bh, "writeout complete: unfile");
  			__journal_unfile_buffer(jh);
  			jbd_unlock_bh_state(bh); 

