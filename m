From: Jan Kara <jack@suse.cz>
Subject: Re: generic/095 triggers lockdep warning in 4.9-rc1
Date: Fri, 21 Oct 2016 09:32:57 +0200
Message-ID: <20161021073257.GA8271@quack2.suse.cz>
References: <20161020180400.GA2172@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, jack@suse.cz, tytso@mit.edu
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33484 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754916AbcJUHdA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Fri, 21 Oct 2016 03:33:00 -0400
Content-Disposition: inline
In-Reply-To: <20161020180400.GA2172@localhost.localdomain>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 20-10-16 14:04:00, Eric Whitney wrote:
> As reported in today's concall, generic/095 triggered a lockdep warning
> during my regression run on a 4.9-rc1 kernel in the 4k test case using the
> latest xfstests-bld test appliance.  The warning is attached below, and
> involves both ext4's direct I/O path and the quota code.
> 
> This failure is difficult to reproduce - 120 out of 120 subsequent trials in
> the 4k test case completed successfully.  No generic/095 failures occurred in
> any other test appliance test case during regression.  Also, I've not seen
> this particular failure in regression runs prior to 4.9-rc1.

Thanks for report. I've already seen that report in my testing as well and
I'm actually able to reproduce it pretty reliably. It is a result of
changes in lockdep annotation of fs freezing - in particular commit
f1a9622037cd370460fd06bb7e28d0f01ceb8ef1 "fs/super.c: don't fool lockdep in
freeze_super() and thaw_super() paths". And it is a real deadlock
possibility although it is probably close to impossible to hit in practice.

The immediate problem is with lock ranking of dqonoff_mutex which ranks
above fault freeze protection but during fs freezing it gets acquired with
fault freeze protection held. It it on my todo list to look into fixing
this but it won't be trivial so I didn't get to it yet.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
