From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: e2fsprogs make check fails
Date: Tue, 5 May 2015 10:11:04 -0400
Message-ID: <20150505141104.GA12468@thunk.org>
References: <20150505054818.GI11592@birch.djwong.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45850 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993083AbbEEOLF (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 5 May 2015 10:11:05 -0400
Content-Disposition: inline
In-Reply-To: <20150505054818.GI11592@birch.djwong.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, May 04, 2015 at 10:48:18PM -0700, Darrick J. Wong wrote:
> 
> Uhh... I pulled the latest e2fsprogs -next and tried to run 'make check'.
> I think tst_sha256 (and maybe tst_sha512?) need to be pulled out of the
> Makefiles

Oops, sorry, I commented out EXT2FS_SHA256_LENGTH and this caused
tst_sha256 to fail.  I forgot to do a "make clean; make check" pass,
forgetting that the dependencies don't always work for the tst_*
commands.  That's one of those things I should fix...

We are still using sha512 since it's used as part of the password
string-to-key function.

					- Ted
