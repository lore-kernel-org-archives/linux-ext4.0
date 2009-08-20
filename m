From: Nick Dokos <nicholas.dokos@hp.com>
Subject: Re: Compile error in pu branch of e2fsprogs.
Date: Thu, 20 Aug 2009 12:32:13 -0400
Message-ID: <9226.1250785933@alphaville.usa.hp.com>
References: <8693.1250784298@alphaville.usa.hp.com>  <4A8D763E.8040603@redhat.com>
Reply-To: nicholas.dokos@hp.com
Cc: nicholas.dokos@hp.com, "Theodore Ts'o" <tytso@mit.edu>,
	linux-ext4@vger.kernel.org
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:3873 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbZHTQcM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 20 Aug 2009 12:32:12 -0400
In-Reply-To: Message from Eric Sandeen <sandeen@redhat.com>
   of "Thu, 20 Aug 2009 11:13:50 CDT." <4A8D763E.8040603@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> Nick Dokos wrote:
    ...
> >
> > I moved it from there to lib/ext2fs/fiemap.h and that fixes it.
> 
> ...
>
> Would it be better to move the ioctl definition into one place, maybe
> our local copy of fiemap.h?
> 

Is "our local copy of fiemap.h" lib/ext2fs/fiemap.h? If so, yes, that
works (and I think it's better.)

Thanks,
Nick
