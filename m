From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext3: handle corrupted orphan list at mount
Date: Tue, 24 Jun 2008 19:18:57 +0200
Message-ID: <20080624171856.GH9959@duck.suse.cz>
References: <20080607121940.8ee6044a.akpm@linux-foundation.org> <1214258200-16623-1-git-send-email-duaneg@dghda.com> <20080624160810.GC22586@atrey.karlin.mff.cuni.cz> <e9e943910806241016v743ce19s28bdf34177154799@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, sct@redhat.com, adilger@clusterfs.com,
	Sami Liedes <sliedes@cc.hut.fi>
To: Duane Griffin <duaneg@dghda.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:41430 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752674AbYFXRS6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jun 2008 13:18:58 -0400
Content-Disposition: inline
In-Reply-To: <e9e943910806241016v743ce19s28bdf34177154799@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue 24-06-08 18:16:21, Duane Griffin wrote:
> 2008/6/24 Jan Kara <jack@suse.cz>:
> >> +     /*
> >> +      * If the orphans has i_nlinks > 0 then it should be able to be
> >> +      * truncated, otherwise it won't be removed from the orphan list
> >> +      * during processing and an infinite loop will result.
> >> +      */
> >> +     if (inode->i_nlink && !ext3_can_truncate(inode))
> >> +             goto bad_orphan;
> >> +
> >  Maybe I miss something but shouldn't above rather be ||?
> 
> No, it is correct. If i_nlink == 0 the orphan will be deleted in the
> cleanup loop by the iput. If i_nlink > 0 then ext3_truncate is called,
> which usually calls ext3_orphan_del on the way out, thereby removing
> the node from the orphan list. However, if it exits too early
> (basically if the ext3_can_truncate check fails, although there are
> other failure conditions such as OOM that can also cause it to exit
> early) then it doesn't, hence we end up in the infinite loop. So the
> check here says, if this node is not going to be deleted or truncated
> then it is invalid.
  Ah, OK, I forgot that you want to handle also truncation without deletion
of the inode itself. Thanks for explanation.

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
