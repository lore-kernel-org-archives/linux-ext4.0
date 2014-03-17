From: tytso@mit.edu
Subject: Re: [PATCH 0/6 v2] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
Date: Sun, 16 Mar 2014 22:19:09 -0400
Message-ID: <20140317021909.GD14162@thunk.org>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com>
 <20140316190820.GB14162@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:42310 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137AbaCQCTO (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 16 Mar 2014 22:19:14 -0400
Content-Disposition: inline
In-Reply-To: <20140316190820.GB14162@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Mar 16, 2014 at 03:08:20PM -0400, tytso@MIT.EDU wrote:
> If I try running the "dev2" branch, without the xfstests collapse
> range branch pulled in, things are much better (so there's clearly a
> bug in the ZERO_RANGE code path), but there was still a few more
> errors than the baseline.  I'm rerunning those tests so I can be sure
> that the results are repeatable.

Running the tests with the dev2 branch, which includes all of the
ext4-specific ZERO_RANGE patches, we see a regression with shared/243
with 4k and 1k block sizes (as well as 4k in no-journal mode):

shared/243 3s ...	[15:09:34] [15:09:35] [failed, exit status 1] - output mismatch (see /results/results-4k/shared/243.out.bad)
    --- tests/shared/243.out	2014-03-15 13:45:11.000000000 -0400
    +++ /results/results-4k/shared/243.out.bad	2014-03-16 15:09:35.470862837 -0400
    @@ -1,13 +1,3 @@
     QA output created by 243
     wrote 4096/4096 bytes at offset 0
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    -wrote 4096/4096 bytes at offset 0
    -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    -wrote 40960/40960 bytes at offset 0
    -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    ...
    (Run 'diff -u tests/shared/243.out /results/results-4k/shared/243.out.bad'  to see the entire diff)

					- Ted
