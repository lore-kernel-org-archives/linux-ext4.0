From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH 0/3] Remove ext3 filesystem driver
Date: Wed, 15 Jul 2015 08:01:05 -0700
Message-ID: <1436972465.16262.16.camel@perches.com>
References: <1436955987-7305-1-git-send-email-jack@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Jens Axboe <axboe@kernel.dk>, Ted Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1436955987-7305-1-git-send-email-jack@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, 2015-07-15 at 12:26 +0200, Jan Kara wrote:
> I have created this patch set which removes ext3 driver (and some related support
> code) from the kernel. See changelog of patch 2/3 for more details.

It'd be nice if you regenerate 2/3 using
git format-patch -M and resend it.
