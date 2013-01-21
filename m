From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] quota: autoload the quota_v2 module for
 QFMT_VFS_V1 quota format
Date: Mon, 21 Jan 2013 16:10:08 +0100
Message-ID: <20130121151008.GM5588@quack.suse.cz>
References: <20130121054741.GB321@thunk.org>
 <1358750781-5670-1-git-send-email-tytso@mit.edu>
 <1358750781-5670-2-git-send-email-tytso@mit.edu>
 <20130121104017.GD5588@quack.suse.cz>
 <20130121150134.GB5618@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60397 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755947Ab3AUPKK (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jan 2013 10:10:10 -0500
Content-Disposition: inline
In-Reply-To: <20130121150134.GB5618@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 21-01-13 10:01:34, Ted Tso wrote:
> On Mon, Jan 21, 2013 at 11:40:17AM +0100, Jan Kara wrote:
> > On Mon 21-01-13 01:46:21, Ted Tso wrote:
> > > Otherwise, ext4 file systems with the quota feature enable will get a
> > > very confusing "No such process" error message if the quota code is
> > > built as a mdoule and the quota_v2 module has not been loaded.
> >   Thanks for the fix. Should I merge it via my tree or do you plan to do it
> > via your tree?
> 
> I'm happy to keep the patch in my tree (since I need it for my ext4
> quota testing), unless you'd like to take it.  It seems unlikely to
> cause any conflicts with any changes you might have in your quota
> tree, yes?
  Exactly. There shouldn't be any conflicts so just keep it in your tree.
You can add to the patch:
Acked-by: Jan Kara <jack@suse.cz>

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
