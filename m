From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] ext4: drop unneeded BUFFER_TRACE in
 ext4_delete_inline_entry()
Date: Thu, 10 Mar 2016 00:19:30 -0500
Message-ID: <20160310051930.GF4937@thunk.org>
References: <cf471e3cb545a084fc3f05ee6166b96f523153c3.1454255445.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
To: Geliang Tang <geliangtang@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cf471e3cb545a084fc3f05ee6166b96f523153c3.1454255445.git.geliangtang@163.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Sun, Jan 31, 2016 at 11:51:54PM +0800, Geliang Tang wrote:
> BUFFER_TRACE info "call ext4_handle_dirty_metadata" doesn't match the
> code, so drop it.
> 
> Signed-off-by: Geliang Tang <geliangtang@163.com>

Thanks, applied.

						- Ted
