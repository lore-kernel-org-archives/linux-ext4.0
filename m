From: "Theodore Y. Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix hole length detection in ext4_ind_map_blocks()
Date: Sun, 13 May 2018 15:50:42 -0400
Message-ID: <20180513195042.GE14763@thunk.org>
References: <20180510153851.4689-1-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180510153851.4689-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, May 10, 2018 at 05:38:51PM +0200, Jan Kara wrote:
> When ext4_ind_map_blocks() computes a length of a hole, it doesn't count
> with the fact that mapped offset may be somewhere in the middle of the
> completely empty subtree. In such case it will return too large length
> of the hole which then results in lseek(SEEK_DATA) to end up returning
> an incorrect offset beyond the end of the hole.
> 
> Fix the problem by correctly taking offset within a subtree into account
> when computing a length of a hole.
> 
> Fixes: facab4d9711e7aa3532cb82643803e8f1b9518e8
> CC: stable@vger.kernel.org
> Reported-by: Jeff Mahoney <jeffm@suse.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Applied, thanks.

					- Ted
