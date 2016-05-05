From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: Fix oops on corrupted filesystem
Date: Thu, 5 May 2016 11:11:03 -0400
Message-ID: <20160505151103.GA10764@thunk.org>
References: <1462200664-4825-1-git-send-email-jack@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org,
	Vegard Nossum <vegard.nossum@oracle.com>,
	stable@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1462200664-4825-1-git-send-email-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, May 02, 2016 at 04:51:04PM +0200, Jan Kara wrote:
> When filesystem is corrupted in the right way, it can happen
> ext4_mark_iloc_dirty() in ext4_orphan_add() returns error and we
> subsequently remove inode from the in-memory orphan list. However this
> deletion is done with list_del(&EXT4_I(inode)->i_orphan) and thus we
> leave i_orphan list_head with a stale content. Later we can look at this
> content causing list corruption, oops, or other issues. The reported
> trace looked like:...

Applied, thanks.

						- Ted
