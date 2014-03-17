From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 0/6 v2] Introduce FALLOC_FL_ZERO_RANGE flag for
 fallocate
Date: Mon, 17 Mar 2014 13:50:46 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403171346280.30625@localhost.localdomain>
References: <1393355679-11160-1-git-send-email-lczerner@redhat.com> <20140316190820.GB14162@thunk.org> <20140317021909.GD14162@thunk.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-ext4@vger.kernel.org
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838AbaCQMux (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 17 Mar 2014 08:50:53 -0400
In-Reply-To: <20140317021909.GD14162@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, 16 Mar 2014, tytso@mit.edu wrote:

> Date: Sun, 16 Mar 2014 22:19:09 -0400
> From: tytso@mit.edu
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org
> Subject: Re: [PATCH 0/6 v2] Introduce FALLOC_FL_ZERO_RANGE flag for fallocate
> 
> On Sun, Mar 16, 2014 at 03:08:20PM -0400, tytso@MIT.EDU wrote:
> > If I try running the "dev2" branch, without the xfstests collapse
> > range branch pulled in, things are much better (so there's clearly a
> > bug in the ZERO_RANGE code path), but there was still a few more
> > errors than the baseline.  I'm rerunning those tests so I can be sure
> > that the results are repeatable.
> 
> Running the tests with the dev2 branch, which includes all of the
> ext4-specific ZERO_RANGE patches, we see a regression with shared/243
> with 4k and 1k block sizes (as well as 4k in no-journal mode):

Oh, right. This fails because the test really should be deprecated
since we already removed the check in e2fsck - see e2fsprogs commit
010dc7b90d97b93907cbf57b3b44f1c1cad234f6.

In this patch I removed setting the EXT4_INODE_EOFBLOCKS, however I
forgot the mention that in the description. Sorry about that.

Now I am not sure how we want to handle this. Either having it as a
part of this patch just update description, or having the
EXT4_INODE_EOFBLOCKS removal from the fallocate as a separate patch,
which probably make more sense to me. What would you prefer ?

Thanks!
-Lukas

> 
> shared/243 3s ...	[15:09:34] [15:09:35] [failed, exit status 1] - output mismatch (see /results/results-4k/shared/243.out.bad)
>     --- tests/shared/243.out	2014-03-15 13:45:11.000000000 -0400
>     +++ /results/results-4k/shared/243.out.bad	2014-03-16 15:09:35.470862837 -0400
>     @@ -1,13 +1,3 @@
>      QA output created by 243
>      wrote 4096/4096 bytes at offset 0
>      XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>     -wrote 4096/4096 bytes at offset 0
>     -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>     -wrote 40960/40960 bytes at offset 0
>     -XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
>     ...
>     (Run 'diff -u tests/shared/243.out /results/results-4k/shared/243.out.bad'  to see the entire diff)
> 
> 					- Ted
> 
