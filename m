From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 3/6] jbd2: fix duplicate debug label for phase 2
Date: Wed, 12 Jun 2013 22:57:20 -0400
Message-ID: <20130613025720.GE16959@thunk.org>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
 <1370990670-49249-1-git-send-email-paul.gortmaker@windriver.com>
 <1370990670-49249-4-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-rt-users@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1370990670-49249-4-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 11, 2013 at 06:44:27PM -0400, Paul Gortmaker wrote:
> Currently we see this output:
> 
>   $git grep phase fs/jbd2
>   fs/jbd2/commit.c:       jbd_debug(3, "JBD2: commit phase 1\n");
>   fs/jbd2/commit.c:       jbd_debug(3, "JBD2: commit phase 2\n");
>   fs/jbd2/commit.c:       jbd_debug(3, "JBD2: commit phase 2\n");
>   fs/jbd2/commit.c:       jbd_debug(3, "JBD2: commit phase 3\n");
>   fs/jbd2/commit.c:       jbd_debug(3, "JBD2: commit phase 4\n");
>   [...]
> 
> There is clearly a duplicate label for phase 2, and they are
> both active (i.e. not in #if ... #else block).  Rename them to
> be "2a" and "2b" so the debug output is unambiguous.
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Applied, thanks

					- Ted
