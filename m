From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 04/18] e2fsck: fix rule-violating lblk->pblk mappings on
 bigalloc filesystems
Date: Mon, 28 Jul 2014 15:32:38 -0400
Message-ID: <20140728193238.GC17378@thunk.org>
References: <20140726003339.28334.54447.stgit@birch.djwong.org>
 <20140726003404.28334.18860.stgit@birch.djwong.org>
 <C91A6455-139E-4E6B-935F-F00332F76616@dilger.ca>
 <20140726202728.GM6725@thunk.org>
 <20140728175554.GQ8628@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:33048 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbaG1Tcm (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 28 Jul 2014 15:32:42 -0400
Content-Disposition: inline
In-Reply-To: <20140728175554.GQ8628@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 28, 2014 at 10:55:54AM -0700, Darrick J. Wong wrote:
> 
> Hmm... the f_badcluster test seems to be missing from -maint and -next.
> Did it get lost in the merge?

Oh, whoops.  It's in my tree, but I forgot to "git add" the directory.
(Because of some patch conflicts that caused "git am" to be unhappy, I
ended up having to apply the patch manually.)

I'll fix it up and push it out.

						- Ted
