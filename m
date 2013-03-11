From: Jan Kara <jack@suse.cz>
Subject: Re: Mixup with name_len & file_type in e2fsprogs
Date: Mon, 11 Mar 2013 15:18:56 +0100
Message-ID: <20130311141856.GJ29799@quack.suse.cz>
References: <20130305121856.GA11824@quack.suse.cz>
 <20130305182946.GB26122@thunk.org>
 <20130305184138.GA19601@quack.suse.cz>
 <20130307182444.GA21237@quack.suse.cz>
 <20130308004620.GB29720@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54133 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab3CKOS6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 11 Mar 2013 10:18:58 -0400
Content-Disposition: inline
In-Reply-To: <20130308004620.GB29720@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 07-03-13 19:46:20, Ted Tso wrote:
> By the way, why was the application trying to access the directory
> entries directly, as opposed to using some of the higher level
> functions in libext2fs?  What was it trying to do?
  It was btrfs-convert (I could have told that in my original email as well
but it didn't seem important) - i.e. inplace convertor from ext4 to btrfs.
So it really needed to get the file type from the directory block to fill
in appropriate btrfs structures.

> Is there some new higher-level functionality we should be providing?
> Or was this just an application that didn't know about some better
> interface that it could have used?  Is this an open source
> application?  Can you send me a pointer to it?
  btrfs-convert is part of btrfsprogs so feel free to have a look. I don't
think we can actually provide some high level functionality to serve its
needs. It really just needs to do readdir(2) on fs image which is what is
already implemented in libext2fs.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
