From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] blockgroup_lock.h: remove debris from bgl_lock_ptr()
 conversion
Date: Thu, 15 Sep 2016 18:24:51 -0400
Message-ID: <20160915222451.tpsl4jt4t4ovdbrc@thunk.org>
References: <1473881279-122959-1-git-send-email-ebiggers@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: Eric Biggers <ebiggers@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1473881279-122959-1-git-send-email-ebiggers@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Sep 14, 2016 at 12:27:59PM -0700, Eric Biggers wrote:
> An obsolete comment and extra parentheses were left over from when the
> sb_bgl_lock() macro was replaced with the bgl_lock_ptr() function.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Applied, thanks.

						- Ted
