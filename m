From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH -v2] ext4: rearrange initialization to fix EXT4FS_DEBUG
Date: Mon, 14 Jul 2014 14:09:51 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1407141409210.13527@localhost.localdomain>
References: <1405181415-1403-1-git-send-email-tytso@mit.edu> <alpine.LFD.2.00.1407140959450.13527@localhost.localdomain> <20140714115623.GC8935@thunk.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-381596153-1405339794=:13527"
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:63730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbaGNMJ7 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 14 Jul 2014 08:09:59 -0400
In-Reply-To: <20140714115623.GC8935@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-381596153-1405339794=:13527
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Mon, 14 Jul 2014, Theodore Ts'o wrote:

> Date: Mon, 14 Jul 2014 07:56:23 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
> Subject: Re: [PATCH -v2] ext4: rearrange initialization to fix EXT4FS_DEBUG
> 
> On Mon, Jul 14, 2014 at 10:04:47AM +0200, Lukáš Czerner wrote:
> > > +	block = ext4_count_free_clusters(sb);
> > > +	ext4_free_blocks_count_set(sbi->s_es, block);
> > 
> > 
> > This does not seem right. block is in cluster units so we need to
> > convert.
> > 
> > 	ext4_free_blocks_count_set(sbi->s_es, EXT4_C2B(sbi, blocks));
> > 
> > Otherwise it looks good to me.
> 
> Thanks, for catching this!   II've fixed up the patch on the ext4 git tree.
> 
> 					- Ted

In that case, you can add.

Reviewed-by: Lukas Czerner <lczerner@redhat.com>

Thanks!
-Lukas
--8323328-381596153-1405339794=:13527--
