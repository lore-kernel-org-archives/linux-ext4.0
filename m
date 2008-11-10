From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext3 aborts journal
Date: Mon, 10 Nov 2008 10:01:47 -0600
Message-ID: <49185AEB.5070302@redhat.com>
References: <20081110075704.GA31730@gamma.logic.tuwien.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Norbert Preining <preining@logic.at>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52666 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbYKJQBx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 10 Nov 2008 11:01:53 -0500
In-Reply-To: <20081110075704.GA31730@gamma.logic.tuwien.ac.at>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Norbert Preining wrote:
> Hi all,
> 
> (please Cc)
> 
> just a few minutes ago my laptop told me:
> 
> [ 4759.267418] __log_wait_for_space: no transactions
> [ 4759.267428] Aborting journal on device sda3.
> [ 4759.267469] ext3_abort called.
> [ 4759.267474] EXT3-fs error (device sda3): ext3_journal_start_sb: Detected aborted journal
> [ 4759.267481] Remounting filesystem read-only
> [ 4759.267727] journal commit I/O error
> [ 4784.453791] Monitor-Mwait will be used to enter C-2 state
> 
> That made me a bit nervous. It is with kernel 2.6.28-rc3, now I rebooted
> in to -rc4.
> 
> Any comments or explanations? Do I have to take any action? Reformat,
> ...?
> 
> Best wishes
> 
> Norbert

I believe this was fixed by:

From: Theodore Ts'o <tytso@mit.edu>
Date: Fri, 7 Nov 2008 03:37:59 +0000 (-0500)
Subject: jbd: don't give up looking for space so easily in
__log_wait_for_space
X-Git-Url:
http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git;a=commitdiff_plain;h=e219cca082f52e7dfea41f3be264b7b5eb204227

jbd: don't give up looking for space so easily in __log_wait_for_space

Commit be07c4ed introducd a regression because it assumed that if
there were no transactions ready to be checkpointed, that no progress
could be made on making space available in the journal, and so the
journal should be aborted.  This assumption is false; it could be the
case that simply calling cleanup_journal_tail() will recover the
necessary space, or, for small journals, the currently committing
transaction could be responsible for chewing up the required space in
the log, so we need to wait for the currently committing transaction
to finish before trying to force a checkpoint operation.

This patch fixes the bug reported by Meelis Roos at:
http://bugzilla.kernel.org/show_bug.cgi?id=11937

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Duane Griffin <duaneg@dghda.com>
Cc: Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
---

-Eric

> -------------------------------------------------------------------------------
> Dr. Norbert Preining <preining@logic.at>        Vienna University of Technology
> Debian Developer <preining@debian.org>                         Debian TeX Group
> gpg DSA: 0x09C5B094      fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
> -------------------------------------------------------------------------------
> QUALL (vb.)
> To speak with the voice of one who requires another to do something
> for them.
> 			--- Douglas Adams, The Meaning of Liff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

