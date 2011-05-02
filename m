From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC][PATCH] Re: [BUG] ext4: cannot unfreeze a filesystem due
 to a deadlock
Date: Mon, 02 May 2011 09:01:50 -0500
Message-ID: <4DBEB94E.5040901@redhat.com>
References: <20110217104552.GD4947@quack.suse.cz> <20110328170628.ffe314fb.toshi.okajima@jp.fujitsu.com> <20110331234050.GD2904@dastard> <20110401140856.GA5311@quack.suse.cz> <20110406054005.GD31057@dastard> <20110406061856.GC23285@quack.suse.cz> <20110406112135.GE31057@dastard> <4DBE746F.3090707@ubuntu.com> <20110502105629.GA4556@quack.suse.cz> <4DBE9537.4050708@ubuntu.com> <20110502122055.GB5855@quack.suse.cz> <4DBEA3DF.1060306@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
	Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>,
	"Ted Ts'o" <tytso@mit.edu>,
	Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
To: surbhi.palande@ubuntu.com
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab1EBOCG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 2 May 2011 10:02:06 -0400
In-Reply-To: <4DBEA3DF.1060306@ubuntu.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 5/2/11 7:30 AM, Surbhi Palande wrote:

...

> Yes, but ext4_freeze() also calls jbd2_journal_unlock_updates(journal) which decrements the  j_barrier_count (which was previously updated/incremented in jbd2_journal_lock_updates) ? before it returns. So after this call a new transaction/handle can be accepted/started.
> 
> A comment in ext4_freeze() says:
> /* we rely on s_frozen to stop further updates */
> (before calling jbd2_journal_unlock_updates())

that was me; 

commit 6b0310fbf087ad6e9e3b8392adca97cd77184084
Author: Eric Sandeen <sandeen@redhat.com>
Date:   Sun May 16 02:00:00 2010 -0400

    ext4: don't return to userspace after freezing the fs with a mutex held


otherwise we return to userspace holding a mutex :(

-Eric
