From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 5/6] kvm-xfstests: add initrd support
Date: Fri, 19 Aug 2016 19:40:52 -0400
Message-ID: <20160819234052.GC12834@thunk.org>
References: <1471553651-9547-1-git-send-email-dmonakhov@openvz.org>
 <1471553651-9547-6-git-send-email-dmonakhov@openvz.org>
 <20160819134432.GH10888@thunk.org>
 <874m6g7tc5.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:47610 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754781AbcHSXlG (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 19 Aug 2016 19:41:06 -0400
Content-Disposition: inline
In-Reply-To: <874m6g7tc5.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Aug 19, 2016 at 04:59:22PM +0300, Dmitry Monakhov wrote:
> No problem, but it looks like my knowledge about GCE is too low at the
> moment. BTW are there are any way to make a bullet prof method to stop
> gce instance after predefined timout? Your systemctl timeout script
> does not always work. In my case it stuck somewhere inside FS and
> timeout.service can not do it's job. Probably we can do it via
> kernel watchdog or external watcher ala Jenkins.

My long term vision was to use an external watcher that would run in
Google App Engine.  The idea would be that this would also take care
of launching separate VM's for each of the different test cases, and
then collate the reports into a single test report.  Long term I'd
also like to have the results stored into Google Cloud Datastore, and
do automatic flaky test detection.

For now, I just simply manually keep an eye on things using
"gce-xfstests ls -l", and if I see something running for too long,
I'll connect to it using "gce-xfstests console xfstests-XXXX" to grab
the results.  In the app-engine test runner vision it would use the
equivalent of "gce-xfstests serial xfstests-XXX" and store the
complete serial console output someplace safe.  What happens today
tends to be:

1) gce-xfstests -c overlay -g auto

2) periodically I'll run gce-xfstests ls -l, and notice when the VM
apparently is no longer making foreward progress.

3) Hmm, looks like overlayfs is blowing up.  And gce-xfstests console
doesn't give me enough history since it only stores the last N lines".

4) gce-xfstests abort xfstests-XXXXXX

5) rerun "gce-xfstests -c overaly -g auto", but now after it starts,
   also run: "script -c "gce-xfstests serial xfstests-XXXXX" console-XXXXX.out"

In practice this doesn't happen often enough that I've automated this,
and it's also why I haven't made it a high priority to create some
kind of external test running / monitoring service.

     		      	      		   - Ted

P.S. I recently added overlayfs support, and it looks like overlayfs
has a bug which ends up screwing up an inode link's count, and causing
the ext4 orphan list to get corrupted, and causing subsequent ext4
warnings and BUG's to get triggered.  So this isn't a hypothetical
example; it's just one that I haven't had time to track down yet.  :-)
