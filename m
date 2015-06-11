From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 11/14] libext2fs: use fallocate for creating journals
 and hugefiles
Date: Wed, 10 Jun 2015 20:12:31 -0400
Message-ID: <20150611001231.GF24181@thunk.org>
References: <20150514002108.10785.85860.stgit@birch.djwong.org>
 <20150514002219.10785.76994.stgit@birch.djwong.org>
 <20150518211826.GK30577@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:58958 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbbFKCmx (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 10 Jun 2015 22:42:53 -0400
Content-Disposition: inline
In-Reply-To: <20150518211826.GK30577@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 18, 2015 at 02:18:26PM -0700, Darrick J. Wong wrote:
> Use the new fallocate API for creating the journal and the mk_hugefile
> feature.
> 
> v2: Use all remaining disk space when the hugefile size is zero.  This
> was a corner case that I missed.  Also fix a bug where the goal didn't
> get used; this fixes a lot of churn in the test case expect files.
> 
> Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>

Thanks, applied.

						- Ted
