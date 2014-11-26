From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: ext4: possible unsafe locking scenario
Date: Wed, 26 Nov 2014 10:28:21 -0500
Message-ID: <20141126152821.GA4004@thunk.org>
References: <20141126145951.GA2750@swordfish>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141126145951.GA2750@swordfish>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Nov 26, 2014 at 11:59:51PM +0900, Sergey Senozhatsky wrote:
> Hello,
> 
> locked spew with the current -next.

Hmm.... what was the system doing at that time?  Is it something that
reliably reproduces, or is this a one-off?

Thanks,

						- Ted
