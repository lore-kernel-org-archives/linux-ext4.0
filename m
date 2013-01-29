From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/2] Ext3: remove a useless check for the function
 ext3_free_blocks_sb
Date: Tue, 29 Jan 2013 15:40:14 +0100
Message-ID: <20130129144014.GE32246@quack.suse.cz>
References: <51045F97.9070602@gmail.com>
 <20130128140757.GB32246@quack.suse.cz>
 <510765B1.7000100@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org
To: Wang Shilong <wangshilong1991@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59125 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567Ab3A2Ok0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 29 Jan 2013 09:40:26 -0500
Content-Disposition: inline
In-Reply-To: <510765B1.7000100@gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon 28-01-13 22:01:21, Wang Shilong wrote:
> =E4=BA=8E 2013-1-28 6:07, Jan Kara =E5=86=99=E9=81=93:
> > On Sat 26-01-13 14:58:31, Wang Shilong wrote:
> >> From: Wang Shilong <wangsl-fnst@cn.fujitsu.com>
> >>
> >> Because 'block + count < block' always comes to false, it is usele=
ss
> >> to have this check, just remove it.
> >   As Andreas commented, the test is actually correct. BTW any reaso=
n why
> > you sent the patch three times?
> My linux run in the virtual machine..and the clock is wrong...so i se=
nd the patch not clarified correctly
> in marc.info..when i find it..I correct it, but first time i correct =
the time as 2012....how stupid it was..:-[
> so i send the patch three times...sorry to bother...
>=20
> BTW =EF=BC=8C may i have a question....
> As we know the block to be freed can not be superblock and GDT..
> I don't see any check about it in ext2/ext3/ext4....
  Yes, you are right we apparently don't check for superblock or GDT
blocks. But checking for those will be a bit more complex and they are
really scarce so I don't think it's worth the overhead.

								Honza
--=20
Jan Kara <jack@suse.cz>
SUSE Labs, CR
--
To unsubscribe from this list: send the line "unsubscribe linux-ext4" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
