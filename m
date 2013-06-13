From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/6] jbd/jbd2: relocate bit_spinlock header to jbd_common
Date: Wed, 12 Jun 2013 23:02:23 -0400
Message-ID: <20130613030223.GF16959@thunk.org>
References: <1370892723-30860-1-git-send-email-paul.gortmaker@windriver.com>
 <1370990670-49249-1-git-send-email-paul.gortmaker@windriver.com>
 <1370990670-49249-5-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-rt-users@vger.kernel.org
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-rt-users-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1370990670-49249-5-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-rt-users-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jun 11, 2013 at 06:44:28PM -0400, Paul Gortmaker wrote:
> The bit_spinlock functions are only used for the jbd_lock_bh_state
> functions (and friends) in jbd_common.h and are not directly used
> by either of jbd.h or jbd2.h content.
> 
> The jbd_common file is new as of commit 446066724c36 ("jdb/jbd2: factor
> out common functions from the jbd[2] header files") but common
> (and isolated) headers were not considered for factoring at that time.
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Thanks, applied.

						- Ted
