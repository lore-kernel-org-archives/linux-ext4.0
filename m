From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] jbd2: Fix use after free in kjournald2()
Date: Wed, 1 Feb 2017 20:56:28 -0500
Message-ID: <20170202015628.xl3vtta466ikeve6@thunk.org>
References: <1485970311-22014-1-git-send-email-stummala@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Sahitya Tummala <stummala@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1485970311-22014-1-git-send-email-stummala@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Feb 01, 2017 at 11:01:51PM +0530, Sahitya Tummala wrote:
> Below is the synchronization issue between unmount and kjournald2
> contexts, which results into use after free issue in kjournald2().
> Fix this issue by using journal->j_state_lock to synchronize the
> wait_event() done in journal_kill_thread() and the wake_up() done
> in kjournald2().

Thanks, applied.

					- Ted
