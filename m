From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 13/32] ext4: ext4_xattr_value_same() should return false
 for external data
Date: Wed, 21 Jun 2017 22:04:41 -0400
Message-ID: <20170622020441.qxkbtonyfia7hkuo@thunk.org>
References: <20170621212142.16581-1-tahsin@google.com>
 <20170621212142.16581-13-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170621212142.16581-13-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 02:21:23PM -0700, Tahsin Erdogan wrote:
> ext4_xattr_value_same() is used as a quick optimization in case the new
> xattr value is identical to the previous value. When xattr value is
> stored in a xattr inode the check becomes expensive so it is better to
> just assume that they are not equal.
> 
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Thanks, added to the ext4 patch queue.

					- Ted
