From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] common/rc: ext4 doesn't support O_DIRECT with data
 journaling
Date: Thu, 11 Jan 2018 13:21:24 -0500
Message-ID: <20180111182124.GA30608@thunk.org>
References: <20180110211905.4ulqeqnwbs2bh66o@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180110211905.4ulqeqnwbs2bh66o@localhost.localdomain>
Sender: fstests-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jan 10, 2018 at 04:19:05PM -0500, Eric Whitney wrote:
> Modify _require_odirect() to skip O_DIRECT tests if the ext4 mount
> option data=journal has been applied.  Because ext4 disables its
> O_DIRECT support when in data journaling mode, no significant value is
> obtained by running these tests and they consume a significant amount
> of run time.  Additionally, this change eliminates the need to triage
> false negative O_DIRECT test results caused by test problems, as has
> occurred from time to time.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
