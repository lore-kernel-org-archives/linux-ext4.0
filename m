From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4: Add support for data=alloc_on_commit mode
Date: Thu, 19 Mar 2009 16:50:08 -0500
Message-ID: <49C2BE10.8080701@redhat.com>
References: <1237259998-12656-1-git-send-email-tytso@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:50461 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754737AbZCSVuZ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 19 Mar 2009 17:50:25 -0400
In-Reply-To: <1237259998-12656-1-git-send-email-tytso@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Theodore Ts'o wrote:
> Add an ext3 bug-for-bug compatible analogue for data=ordered mode.  In
> this mode, we force all delayed allocation blocks involved with the
> to-be-commited transaction to be allocated, and then flushed out to
> disk before the transaction is commited.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

For fun I ran compilebench -i 10 -r 30 on this on a sata drive:

ext3 run complete:
==========================================================================
intial create total runs 10 avg 43.74 MB/s (user 0.58s sys 3.51s)
create total runs 5 avg 34.94 MB/s (user 0.58s sys 3.34s)
patch total runs 4 avg 21.07 MB/s (user 0.34s sys 3.42s)
compile total runs 7 avg 59.41 MB/s (user 0.14s sys 3.54s)
clean total runs 4 avg 427.96 MB/s (user 0.03s sys 0.52s)
read tree total runs 2 avg 23.94 MB/s (user 0.86s sys 5.29s)
read compiled tree total runs 1 avg 52.59 MB/s (user 0.91s sys 7.30s)
delete tree total runs 2 avg 5.25 seconds (user 0.48s sys 3.25s)
no runs for delete compiled tree
stat tree total runs 4 avg 4.11 seconds (user 0.50s sys 2.39s)
stat compiled tree total runs 1 avg 4.26 seconds (user 0.47s sys 2.58s)

ext4 default run complete:
==========================================================================
intial create total runs 10 avg 51.51 MB/s (user 0.60s sys 3.26s)
create total runs 5 avg 38.20 MB/s (user 0.57s sys 3.34s)
patch total runs 4 avg 22.80 MB/s (user 0.35s sys 3.48s)
compile total runs 7 avg 67.25 MB/s (user 0.13s sys 2.52s)
clean total runs 4 avg 687.29 MB/s (user 0.02s sys 0.39s)
read tree total runs 2 avg 24.05 MB/s (user 0.85s sys 5.27s)
read compiled tree total runs 1 avg 56.56 MB/s (user 0.99s sys 7.08s)
delete tree total runs 2 avg 3.85 seconds (user 0.35s sys 2.69s)
no runs for delete compiled tree
stat tree total runs 4 avg 2.78 seconds (user 0.36s sys 1.74s)
stat compiled tree total runs 1 avg 3.00 seconds (user 0.37s sys 1.88s)

ext4 alloc_on_commit run complete:
==========================================================================
intial create total runs 10 avg 46.96 MB/s (user 0.59s sys 3.34s)
create total runs 5 avg 37.80 MB/s (user 0.59s sys 3.26s)
patch total runs 4 avg 22.27 MB/s (user 0.33s sys 3.58s)
compile total runs 7 avg 65.96 MB/s (user 0.13s sys 2.60s)
clean total runs 4 avg 589.56 MB/s (user 0.03s sys 0.37s)
read tree total runs 2 avg 22.33 MB/s (user 0.86s sys 5.31s)
read compiled tree total runs 1 avg 55.71 MB/s (user 1.04s sys 7.07s)
delete tree total runs 2 avg 3.99 seconds (user 0.34s sys 2.69s)
no runs for delete compiled tree
stat tree total runs 4 avg 2.95 seconds (user 0.35s sys 1.74s)
stat compiled tree total runs 1 avg 3.18 seconds (user 0.39s sys 1.86s)

A bit slower than default, to be expected I guess.  Still faster than
ext3, which is... nice.  Didn't hang or oops :)

-Eric
