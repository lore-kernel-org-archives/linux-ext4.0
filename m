From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 26/36] fs/ext4: Remove unnecessary casts of private_data
Date: Fri, 23 Jul 2010 08:56:39 -0400
Message-ID: <20100723125639.GB13090@thunk.org>
References: <cover.1278967120.git.joe@perches.com>
 <57404f1380cc8d0609b5bd7ce178a8e9eddd2a06.1278967121.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org
To: Joe Perches <joe@perches.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:45928 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757709Ab0GWM4o (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 23 Jul 2010 08:56:44 -0400
Content-Disposition: inline
In-Reply-To: <57404f1380cc8d0609b5bd7ce178a8e9eddd2a06.1278967121.git.joe@perches.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 12, 2010 at 01:50:18PM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/ext4/dir.c     |    2 +-
>  fs/ext4/mballoc.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Thanks, applied to the ext4 tree.

					- Ted
