From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/1 linux-next] jbd2: Fix sparse context imbalance warning
Date: Thu, 18 Sep 2014 16:44:55 -0400
Message-ID: <20140918204455.GA26995@thunk.org>
References: <1411064974-18304-1-git-send-email-fabf@skynet.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
To: Fabian Frederick <fabf@skynet.be>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1411064974-18304-1-git-send-email-fabf@skynet.be>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Sep 18, 2014 at 08:29:34PM +0200, Fabian Frederick wrote:
> spin_unlock after spin_lock only.
> 
> This fixes the following sparse warning:
> fs/jbd2/transaction.c:1102:20: warning: context imbalance
> in 'jbd2_journal_get_create_access' - different lock contexts for basic block
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

NAK, this is a case where I think it's better to make the static
analyzers better.  In any case sparse gives a lot of false positives
for this particular warning, so adding lines of code to try to shut up
sparse for every single false positive seems to be a losing
proposition.

I'll note that these sorts of bugs are much more easily picked up
using lockdep in any case, so we're probably better of just ignoring
these sorts of warnings.  Better to let the 0day kernel tester warn
for new sparse warnings, instead of trying to drive sparse warnings
down to zero.

Cheers,

					- Ted
