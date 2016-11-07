From: Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] A proposal for adding case insensitive lookups to ext4
Date: Mon, 7 Nov 2016 15:30:35 +1100
Message-ID: <20161107043035.GH28177@dastard>
References: <20161103172842.q7avc7rztny3zndd@thunk.org>
 <E33408BD-68CC-49E4-9B32-EC06DB057509@dilger.ca>
 <20161104215105.waabpcf7zganrdbr@thunk.org>
 <20161106235722.GG28177@dastard>
 <20161107001456.muvwkwlqxucrzpzi@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andreas Dilger <adilger@dilger.ca>,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        guy@linux.com, jra@google.com, drosen@google.com, hch@infradead.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:4236 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751187AbcKGEay (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 6 Nov 2016 23:30:54 -0500
Content-Disposition: inline
In-Reply-To: <20161107001456.muvwkwlqxucrzpzi@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Nov 06, 2016 at 07:14:56PM -0500, Theodore Ts'o wrote:
> I talked to Christoph at the Plumbers Closing party, and he suggested
> that we get something simple in first which (a) assumes no on-disk
> format changes, (b) does everything in the VFS layer, by using a
> MS_CASE_FOLD, uses a case-insensitive dentry hash, and which degrades
> to a brute force search in the VFS by using readdir interfaces if the
> direct lookup does not succeed, and (c) at least initially assumes
> only ASCII.
> 
> This could be extended by individual file systems who are willing to
> make on-disk format changes.

OK, as long people are ok with things going wonky when the
filesystem is mounted without those mount options, I'm not really
fussed...

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
