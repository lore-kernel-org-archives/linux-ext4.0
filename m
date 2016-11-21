From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: remove unused function ext4_aligned_io()
Date: Mon, 21 Nov 2016 11:54:13 -0500
Message-ID: <20161121165413.d6gnveh7t7xbgtaw@thunk.org>
References: <1479458830-22955-9-git-send-email-jack@suse.cz>
 <1479704537-21069-1-git-send-email-ross.zwisler@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1479704537-21069-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Nov 20, 2016 at 10:02:17PM -0700, Ross Zwisler wrote:
> The last user of ext4_aligned_io() was the DAX path in
> ext4_direct_IO_write().  This usage was removed by Jan Kara's patch
> entitled "ext4: Rip out DAX handling from direct IO path".
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Applied, thanks.

						- Ted
