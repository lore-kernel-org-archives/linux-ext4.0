From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] quota: autoload the quota_v2 module for
 QFMT_VFS_V1 quota format
Date: Mon, 21 Jan 2013 20:08:10 +0100
Message-ID: <20130121190810.GA20178@quack.suse.cz>
References: <20130121054741.GB321@thunk.org>
 <1358750781-5670-1-git-send-email-tytso@mit.edu>
 <1358750781-5670-2-git-send-email-tytso@mit.edu>
 <20130121104017.GD5588@quack.suse.cz>
 <20130121150134.GB5618@thunk.org>
 <20130121151008.GM5588@quack.suse.cz>
 <20130121155020.GD5618@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	stable@vger.kernel.org, adityakali@google.com, adilger@dilger.ca
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43180 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab3AUTIP (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 21 Jan 2013 14:08:15 -0500
Content-Disposition: inline
In-Reply-To: <20130121155020.GD5618@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 21-01-13 10:50:20, Ted Tso wrote:
> On Mon, Jan 21, 2013 at 04:10:08PM +0100, Jan Kara wrote:
> >   Exactly. There shouldn't be any conflicts so just keep it in your tree.
> > You can add to the patch:
> > Acked-by: Jan Kara <jack@suse.cz>
> 
> Great, thanks.
> 
> BTW, do you have any plans to work on getting repquota support for
> ocfs2 and ext4 with the internal quota support into quotactl(2) and
> quotatools?  It's missing functionality that I think users who want to
> switch to the internal quota support will very much care about.
  As Carlos mentioned, it kind-of works. If repquota(8) doesn't have a way
to iterate over quota structures directly, it iterates over entries in
/etc/passwd and uses Q_GETQUOTA to find the information. It is not a
perfect solution (e.g. when you have a huge LDAP database instead of
/etc/passwd) but in lots of cases it works just fine.

> 5) Add some kind of functional replacement for repquota.  If
> quotactl(2) support is not forthcoming in the near future, at the very
> least debugfs should have a way of dumping out the repquota
> information for an unmounted ext4 file system with internal quotas
> enabled.
  I have it on my todo list for a long time. The problem is noone wants it
enough to get to the top of the list... Also it won't be completely trivial
interface because we'll have to return some handle with which we could
associate scanning state. My plan would be to likely return an ordinary
read-only file handle (mostly to avoid various problems with what happens
when process exits without closing the handle or what happens on fork)
where f_pos would mean [ug]id to report next and reading would fill the
buffer with quota structures (if_dqblk + [ug]id). But I haven't tried
coding this...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
