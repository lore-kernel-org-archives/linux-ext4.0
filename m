From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 4/7] ext4: refactor punch hole code
Date: Wed, 27 Mar 2013 11:49:22 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1303271147320.23176@localhost>
References: <1364170014-10295-1-git-send-email-tytso@mit.edu> <1364170014-10295-5-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1303261334060.2455@(none)> <20130327023816.GC2697@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-183794955-1364381365=:23176"
Cc: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948Ab3C0Kt1 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 27 Mar 2013 06:49:27 -0400
In-Reply-To: <20130327023816.GC2697@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-183794955-1364381365=:23176
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Tue, 26 Mar 2013, Theodore Ts'o wrote:

> Date: Tue, 26 Mar 2013 22:38:16 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Subject: Re: [PATCH 4/7] ext4: refactor punch hole code
> 
> On Tue, Mar 26, 2013 at 01:54:19PM +0100, Lukáš Czerner wrote:
> > > +	/* Wait all existing dio workers, newcomers will block on i_mutex */
> > > +	ext4_inode_block_unlocked_dio(inode);
> > 
> > This was not present in the indirect punch hole code, does it means
> > that there was a bug ? If so maybe it's worth mentioning in the
> > description? 
> 
> Yes, I'm pretty sure it was a bug.  The
> ext4_inode_block_unlocked_dio() call was added in the extents code
> path by commit 02d262dffcf4c.  The problem is that i_mutex will not
> block DIO readers in dioread_nolock mode.  One of the problems with
> not having done the code refactorization earlier was that a bug fixed
> in one code path doesn't necessarily get fixed in another.
> 
> I'll add a comment to this effect in the commit description.

Great, thanks.

> 
> > > +	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
> > > +		credits = ext4_writepage_trans_blocks(inode);
> > > +	else
> > > +		credits = ext4_blocks_for_truncate(inode);
> > > +	handle = ext4_journal_start(inode, EXT4_HT_TRUNCATE,
> > > +				    ext4_blocks_for_truncate(inode));
> > 
> > Hmm, shouldn't we be using 'credits' instead of
> > ext4_blocks_for_truncate(inode) here ?
> 
> Yes, good catch!
> 
> Thanks,
> 

I am not sure why I do not see my mail on the ext4 list.. But
anyway, you've missed my last comment bellow this one.

-Lukas

> 						- Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
--8323328-183794955-1364381365=:23176--
