From: Alan Stern <stern@rowland.harvard.edu>
Subject: RE: [Bug 25832] kernel crashes when a mounted ext3/4 file system is
 physically removed
Date: Sat, 17 Sep 2011 09:21:23 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1109170913500.15004-100000@netrider.rowland.org>
References: <BAY151-W1224E6C1A20D179965A149A1090@phx.gbl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: tytso@mit.edu, <linux-ext4@vger.kernel.org>
To: Rocko Requin <rockorequin@hotmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:45364 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751929Ab1IQNVY (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 17 Sep 2011 09:21:24 -0400
In-Reply-To: <BAY151-W1224E6C1A20D179965A149A1090@phx.gbl>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Please don't include an entire 400-line message in your reply if you're
only going to add a few new lines of text.  Use some judicious trimming.

On Sat, 17 Sep 2011, Rocko Requin wrote:

> Here's a log of the latest kernel from git crashing with that patch
> applied (as well as Ted's patch), does it help any?

It does.  It shows a new problem that's completely unrelated to the 
earlier one.

> The gnome-terminal console cursor

Why were you using gnome-terminal?  You should be running the tests at
a console VT, not under X at all.  Ctrl-Alt-F2 or the equivalent...

>  stopped flashing after the last
> 'detaching wakeup' message for a while (it *seemed* to have locked up
> at this point) but then it came back after what looks like 17 seconds
> or so from the log (apport reported something else crashing at this
> point) and then the oops happened and it crashed for good.

Here's another patch to address the new problem.  You can apply it on 
top of all the other patches.

Alan Stern


Index: usb-3.1/block/blk-core.c
===================================================================
--- usb-3.1.orig/block/blk-core.c
+++ usb-3.1/block/blk-core.c
@@ -367,8 +367,10 @@ void blk_cleanup_queue(struct request_qu
 	queue_flag_set_unlocked(QUEUE_FLAG_DEAD, q);
 	mutex_unlock(&q->sysfs_lock);
 
-	if (q->elevator)
+	if (q->elevator) {
 		elevator_exit(q->elevator);
+		q->elevator = NULL;
+	}
 
 	blk_throtl_exit(q);
 
Index: usb-3.1/block/elevator.c
===================================================================
--- usb-3.1.orig/block/elevator.c
+++ usb-3.1/block/elevator.c
@@ -812,7 +812,7 @@ void elv_completed_request(struct reques
 	 */
 	if (blk_account_rq(rq)) {
 		q->in_flight[rq_is_sync(rq)]--;
-		if ((rq->cmd_flags & REQ_SORTED) &&
+		if ((rq->cmd_flags & REQ_SORTED) && e &&
 		    e->ops->elevator_completed_req_fn)
 			e->ops->elevator_completed_req_fn(q, rq);
 	}

