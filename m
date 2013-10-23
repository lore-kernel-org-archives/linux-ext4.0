From: Jan Kara <jack@suse.cz>
Subject: Commit 7d7345322d60edb0fa49a64a89b31360f01d09cb
Date: Wed, 23 Oct 2013 12:38:55 +0200
Message-ID: <20131023103855.GF1275@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ted Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

  Hello,

  can you please consider commit 7d7345322d60edb0fa49a64a89b31360f01d09cb "ext4: fix warning in
ext4_da_update_reserve_space()" for -stable kernels (3.10 & 3.11 would make
sense). Although the problem mostly results only in a warning, it can cause
fs corruption in the rare case of hitting ENOSPC at the wrong moment.

								Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
