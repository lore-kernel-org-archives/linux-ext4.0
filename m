From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 08/15] libext2fs: fix memory leak on error path
Date: Tue, 21 Dec 2010 18:06:37 -0500
Message-ID: <20101221230637.GA5700@thunk.org>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
 <1291020917-8671-9-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:36915 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab0LUXGj (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Dec 2010 18:06:39 -0500
Content-Disposition: inline
In-Reply-To: <1291020917-8671-9-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 29, 2010 at 05:55:10PM +0900, Namhyung Kim wrote:
> io->name should be freed if ext2fs_file_open2() fails.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Thanks, fixed (although in a slightly different way to avoid the extra
goto label).

					- Ted
