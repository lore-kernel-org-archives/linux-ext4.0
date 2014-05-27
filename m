From: Eric Sandeen <sandeen@redhat.com>
Subject: jbd2 batch time tuning behavior question
Date: Tue, 27 May 2014 11:47:06 -0500
Message-ID: <5384C18A.7040501@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbaE0QrH (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 May 2014 12:47:07 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s4RGl7U9028221
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-ext4@vger.kernel.org>; Tue, 27 May 2014 12:47:07 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com [10.5.9.1])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id s4RGl6kd027150
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <linux-ext4@vger.kernel.org>; Tue, 27 May 2014 12:47:07 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Question for Ted:  With this commit, you introduced some documentation and some code which are not consistent AFAICT:


commit 30773840c19cea60dcef39545960d541b1ac1cf8
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Sat Jan 3 20:27:38 2009 -0500

    ext4: add fsync batch tuning knobs

<snip>

+                       the transaction.   The commit time is capped by
+                       the max_batch_time, which defaults to 15000us
+                       (15ms).   This optimization can be turned off
+                       entirely by setting max_batch_time to 0.

<snip>

+               case Opt_max_batch_time:
+                       if (match_int(&args[0], &option))
+                               return 0;
+                       if (option < 0)
+                               return 0;
+                       if (option == 0)
+                               option = EXT4_DEF_MAX_BATCH_TIME;
+                       sbi->s_max_batch_time = option;
+                       break;

Docs say "0" turns it off, but option handling turns "0" into 
EXT4_DEF_MAX_BATCH_TIME.  What was the real intent here; should the
docs or the behavior be changed?

Thanks,
-Eric
