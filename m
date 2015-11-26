From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] fix an endianness bug in ext4_encrypted_follow_link()
Date: Thu, 26 Nov 2015 15:22:55 -0500
Message-ID: <20151126202255.GE2632@thunk.org>
References: <20151126152728.GT22011@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151126152728.GT22011@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Nov 26, 2015 at 03:27:28PM +0000, Al Viro wrote:
> applying le32_to_cpu() to 16bit value is a bad idea...
>     
> Cc: stable@vger.kernel.org # v4.1+
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Thanks, applied.

						- Ted
