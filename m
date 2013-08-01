From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [PATCH 0/4] Backports of jbd2 commits to jbd
Date: Thu, 1 Aug 2013 15:08:22 -0400
Message-ID: <51FAB226.3040405@windriver.com>
References: <1375383668-8072-1-git-send-email-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
	<linux-ext4@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1375383668-8072-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 13-08-01 03:01 PM, Paul Gortmaker wrote:
> The following commits exist in jbd2, and the backport to jbd is
> relatively straightforward.  In doing so we make the debug enable
> interface consistent between jbd and jbd2.
> 
> For testing, I've booted up a machine with ext3 fs, done some basic
> operations (update a git tree, build a kernel) and also ensured that
> enabling debug via the new /sys/module/jbd/parameters/ entry works.
> Testing was on a baseline of v3.10-rc1-39-g741ddbc.

That should have been v3.11-rc3-40-g75eaff0; the above just happens
to be the 1st non-merge commit on mainline today.
