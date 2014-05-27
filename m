From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] coverity fixes, part 3
Date: Tue, 27 May 2014 13:06:31 -0400
Message-ID: <20140527170631.GF1158@thunk.org>
References: <20140523070815.GB17413@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:35231 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbaE0RGe (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 27 May 2014 13:06:34 -0400
Content-Disposition: inline
In-Reply-To: <20140523070815.GB17413@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 23, 2014 at 12:08:15AM -0700, Darrick J. Wong wrote:
> Fix various small resource leaks and error code handling issues that
> Coverity pointed out.
> 
> Fixes-Coverity-Bugs: 1215250, 1193379, 119194[2-4], 1049160
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Applied, thanks.

					- Ted
