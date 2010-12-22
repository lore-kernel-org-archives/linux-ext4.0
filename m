From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 15/15] mke2fs.8.in: add ENVIRONMENT section
Date: Wed, 22 Dec 2010 10:43:35 -0500
Message-ID: <20101222154335.GH5700@thunk.org>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
 <1291020917-8671-16-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:42892 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab0LVPnh (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 22 Dec 2010 10:43:37 -0500
Content-Disposition: inline
In-Reply-To: <1291020917-8671-16-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 29, 2010 at 05:55:17PM +0900, Namhyung Kim wrote:
> Add ENVIRONMENT section and describe behavior of MKE2FS_SYNC,
> MKE2FS_CONFIG, MKE2FS_FIRST_META_BG, MKE2FS_DEVICE_SECTSIZE
> and MKE2FS_SKIP_CHECK_MSG.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Thanks, applied to the 'next' branch.

					- Ted
