From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 32/32] ext4: add nombcache mount option
Date: Thu, 22 Jun 2017 12:00:41 -0400
Message-ID: <20170622160041.hnqcrt7pnek4obmo@thunk.org>
References: <20170622014939.3592-1-tahsin@google.com>
 <20170622014939.3592-9-tahsin@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Tahsin Erdogan <tahsin@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170622014939.3592-9-tahsin@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Jun 21, 2017 at 06:49:39PM -0700, Tahsin Erdogan wrote:
> The main purpose of mb cache is to achieve deduplication in
> extended attributes. In use cases where opportunity for deduplication
> is unlikely, it only adds overhead.
> 
> Add a mount option to explicitly turn off mb cache.
> 
> Suggested-by: Andreas Dilger <adilger@dilger.ca>
> Signed-off-by: Tahsin Erdogan <tahsin@google.com>

Applied, thanks.

						- Ted
