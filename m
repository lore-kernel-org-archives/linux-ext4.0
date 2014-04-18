From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [ext4] BUG: sleeping function called from invalid context at
 fs/ext4/ext4_jbd2.c:252
Date: Fri, 18 Apr 2014 11:24:56 -0400
Message-ID: <20140418152456.GA31301@thunk.org>
References: <20140417033346.GA8702@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
	Linux Ext4 <linux-ext4@vger.kernel.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140417033346.GA8702@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 17, 2014 at 11:33:46AM +0800, Fengguang Wu wrote:
> 
> FYI, we noticed that simple dd write can trigger the below BUG in
> commit 208b9cc3a32f29b8a9bba682b5bfbb962bc9892d ("ext4: add a new
> spinlock i_raw_lock to protect the ext4's raw inode")

Yes, that was a buggy version of the patch that I thought was fairly
quickly replaced with a new version; something must have gone wrong
with how I pushed out my git branches.  Anyway I'm pretty sure it's
not there on ext4.git any more.  Let me know if you're still seeing
it, and from which branch.

Cheers,

					- Ted
