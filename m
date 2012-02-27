From: Ted Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] build: fix compile warnings on OSX
Date: Mon, 27 Feb 2012 01:29:01 -0500
Message-ID: <20120227062901.GE14204@thunk.org>
References: <1330069737-36009-1-git-send-email-adilger@whamcloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Andreas Dilger <adilger@whamcloud.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:35524 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785Ab2B0G3E (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 27 Feb 2012 01:29:04 -0500
Content-Disposition: inline
In-Reply-To: <1330069737-36009-1-git-send-email-adilger@whamcloud.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Feb 24, 2012 at 12:48:57AM -0700, Andreas Dilger wrote:
> Clean up some compile warnings related to fstat64(), which is
> verbosely deprecated on OSX.
> 
> Signed-off-by: Andreas Dilger <adilger@whamcloud.com>

Thanks, applied.

						- Ted
