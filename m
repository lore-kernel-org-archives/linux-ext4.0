From: tytso@mit.edu
Subject: Re: [PATCH 2/2] fs/ext4: Eliminate double free
Date: Wed, 23 Dec 2009 07:53:34 -0500
Message-ID: <20091223125334.GE21594@thunk.org>
References: <Pine.LNX.4.64.0912201806530.26912@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1755709AbZLWMxk@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0912201806530.26912@ask.diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Dec 20, 2009 at 06:07:10PM +0100, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> b_entry_name and buffer are initially NULL, are initialized within a loop
> to the result of calling kmalloc, and are freed at the bottom of this loop.
> The loop contains gotos to cleanup, which also frees b_entry_name and
> buffer.  Some of these gotos are before the reinitializations of
> b_entry_name and buffer.  To maintain the invariant that b_entry_name and
> buffer are NULL at the top of the loop, and thus acceptable arguments to
> kfree, these variables are now set to NULL after the kfrees.
> 
> This seems to be the simplest solution.  A more complicated solution
> would be to introduce more labels in the error handling code at the end of
> the function.

Thanks, added to the ext4 patch queue.

						- Ted
