From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/4] ext4: Improve ext4 Kconfig test
Date: Thu, 16 Jul 2015 09:59:18 -0400
Message-ID: <20150716135918.GC22531@thunk.org>
References: <1437040386-31148-1-git-send-email-jack@suse.com>
 <1437040386-31148-5-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>
To: Jan Kara <jack@suse.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1437040386-31148-5-git-send-email-jack@suse.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Jul 16, 2015 at 11:53:06AM +0200, Jan Kara wrote:
> Now that ext4 driver must be used to access ext3 filesystems, improve
> the Kconfig help text to better explain that using ext4 driver to access
> the filesystem is fully compatible with the old ext3 driver.
> 
> Signed-off-by: Jan Kara <jack@suse.com>

Acked-by: Theodore Ts'o <tytso@mit.edu>

							- Ted
