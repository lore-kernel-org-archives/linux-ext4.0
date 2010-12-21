From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 10/15] mke2fs.8.in: add missing "big" and "huge"
 usage-type description
Date: Tue, 21 Dec 2010 18:45:21 -0500
Message-ID: <20101221234521.GC5700@thunk.org>
References: <1291020917-8671-1-git-send-email-namhyung@gmail.com>
 <1291020917-8671-11-git-send-email-namhyung@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:47315 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751846Ab0LUXpX (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 21 Dec 2010 18:45:23 -0500
Content-Disposition: inline
In-Reply-To: <1291020917-8671-11-git-send-email-namhyung@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Nov 29, 2010 at 05:55:12PM +0900, Namhyung Kim wrote:
> The commit 493024ea1d74e4cb48aac3a24111f5c8da343e9f ("mke2fs: Fix up the
> fs type and feature selection for 64-bit blocks") added 'big' and 'huge'
> usage-type but was missing description in man page. Add it.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Thanks, applied.

					- Ted
