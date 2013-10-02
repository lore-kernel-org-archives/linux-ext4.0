From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH] ext4: add noorlov parameter to avoid spreading of
 directory inodes
Date: Wed, 2 Oct 2013 19:09:16 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1310021907380.1924@localhost.localdomain>
References: <20131001160817.GA2295@kvack.org> <20131002144759.GB32181@quack.suse.cz> <524C3574.7020106@redhat.com> <20131002153101.GE4353@kvack.org> <alpine.LFD.2.00.1310021838370.1924@localhost.localdomain> <20131002165210.GA16076@kvack.org>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-51958502-1380733759=:1924"
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
To: Benjamin LaHaise <bcrl@kvack.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21152 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754510Ab3JBRJ0 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 2 Oct 2013 13:09:26 -0400
In-Reply-To: <20131002165210.GA16076@kvack.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-51958502-1380733759=:1924
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Wed, 2 Oct 2013, Benjamin LaHaise wrote:

> Date: Wed, 2 Oct 2013 12:52:10 -0400
> From: Benjamin LaHaise <bcrl@kvack.org>
> To: Lukáš Czerner <lczerner@redhat.com>
> Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
>     Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
>     linux-ext4@vger.kernel.org
> Subject: Re: [PATCH] ext4: add noorlov parameter to avoid spreading of
>     directory inodes
> 
> On Wed, Oct 02, 2013 at 06:44:56PM +0200, Lukáš Czerner wrote:
> > What is the frequency of unlink operation in comparison to file
> > creation ? There is a possible issue with the global goal cursors
> > s_mb_last_group and s_mb_last_start which might make your files
> > increasingly scattered across the disk. I've attempted to address
> > this problem with my patch
> 
> unlink() is 1:1 with creation.  The storage on disk is essentially used 
> as an elastic buffer for the rest of the system.  That said, unlink() may 
> not occur for minutes, hours or days.
> 
> In terms of actual allocation pattern on disk, using fallocate() is 
> sufficient to ensure that files on disk are usually limited to 1 extent, 
> and allocated immediately following each other.  Without fallocate(), I 
> was seeing allocations aligned to 2048 block boundaries for 9MB files, 
> which hurt performance quite a bit.

I was not talking about internal file fragmentation but the actual
files lying further from the ideal block group they should have been
laid out.

> 
> > ext4: Try to better reuse recently freed space
> > 
> > What is the usual size of the files this application is creating ?
> 
> It varies.  The target is 8MB, but it ranges from 5MB to 22MB.  In the 
> worst case it can be as small as 4KB.

It means that you're indeed using stream allocation so this issue
would affect you.

> 
> 		-ben
> 
> > Thanks!
> > -Lukas
> 
> 
--8323328-51958502-1380733759=:1924--
