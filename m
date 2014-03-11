From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 01/49] create_inode: clean up return mess in
 do_write_internal
Date: Tue, 11 Mar 2014 17:08:53 -0400
Message-ID: <20140311210853.GK2190@thunk.org>
References: <20140311065356.30585.47192.stgit@birch.djwong.org>
 <20140311065404.30585.9687.stgit@birch.djwong.org>
 <9EBDB4AF-4901-4416-ACC4-6F25233316BD@dilger.ca>
 <20140311204131.GA31864@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>, linux-ext4@vger.kernel.org
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:40112 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755379AbaCKVI4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 11 Mar 2014 17:08:56 -0400
Content-Disposition: inline
In-Reply-To: <20140311204131.GA31864@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Mar 11, 2014 at 01:41:31PM -0700, Darrick J. Wong wrote:
> > This seems a bit strange.  It looks like an error return, but it will
> > actually return "0" since this branch is only entered if retval == 0.
> > Should this return an explicit error value here?
> 
> You're right; maybe we should return EXT2_ET_FILE_EXISTS or something?

EXT2_ET_FILE_EXISTS sounds good to me.

					- Ted
