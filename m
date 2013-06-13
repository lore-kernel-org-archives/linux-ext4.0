From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 1/6] jbd2/journal_commit_transaction: relocate assert
 after state lock
Date: Wed, 12 Jun 2013 22:42:52 -0400
Message-ID: <20130613024252.GC16959@thunk.org>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
 <1370990670-49249-1-git-send-email-paul.gortmaker@windriver.com>
 <1370990670-49249-2-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-rt-users@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1370990670-49249-2-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 11, 2013 at 06:44:25PM -0400, Paul Gortmaker wrote:
> The state lock is taken after we are doing an assert on the state
> value, not before.  So we might in fact be doing an assert on a
> transient value.  Ensure the state check is within the scope of
> the state lock being taken.
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Thanks, applied.

					- Ted
