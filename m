From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] MAINTAINERS: fscrypto: recommend linux-fsdevel for
 fscrypto patches
Date: Sat, 26 Nov 2016 15:05:42 -0500
Message-ID: <20161126200542.4rglbaanjt2udpwq@thunk.org>
References: <1477340955-145575-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, jaegeuk@kernel.org, richard@nod.at
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1477340955-145575-1-git-send-email-ebiggers@google.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Oct 24, 2016 at 01:29:15PM -0700, Eric Biggers wrote:
> The filesystem level encryption support, currently used by ext4 and f2fs
> and proposed for ubifs, does not yet have a dedicated mailing list.
> Since no mailing lists were specified in MAINTAINERS, get_maintainer.pl
> only recommended to send patches directly to the maintainers and to
> linux-kernel.  This patch adds linux-fsdevel as the preferred mailing
> list for fscrypto patches for the time being.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
