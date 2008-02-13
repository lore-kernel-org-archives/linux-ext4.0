From: "Takashi Sato" <t-sato@yk.jp.nec.com>
Subject: Re: [RFC] ext3 freeze feature
Date: Wed, 13 Feb 2008 17:23:14 +0900
Message-ID: <010901c86e19$adaf1730$41a8400a@bsd.tnes.nec.co.jp>
References: <20080125195938t-sato@mail.jp.nec.com> <20080125121851.GA3361@dmon-lap.sw.ru> <20080125133329.GB8184@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
To: "Theodore Tso" <tytso@MIT.EDU>, <linux-ext4@vger.kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50094 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbYBMIZK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 13 Feb 2008 03:25:10 -0500
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

> P.S.  Oh yeah, it should be noted that freezing at the filesystem
> layer does *not* guarantee that changes to the block device aren't
> happening via mmap()'ed files.  The LVM needs to freeze writes the
> block device level if it wants to guarantee a completely stable
> snapshot image.  So the proposed patch doens't quite give you those
> guarantees, if that was the intended goal.

I don't think a mmap()'ed file is written to a block device while a filesystem
is frozen.  pdflush starts the writing procedure of the mmap()'ed file's
data and calls ext3_ordered_writepage.  ext3_ordered_writepage calls
ext3_journal_start to get the journal handle.  As a result, the process
waits for unfreeze in start_this_handle.
pdflush
:    :
ext3_ordered_writepage
ext3_journal_start
ext3_journal_start_sb
journal_start
start_this_handle <--- wait here

I actually tried freezing the filesystem after updating the mmap()'ed
file's data.  But, the writing to the block device didn't happen.
(It happened right after unfreeze.)

I don't think the freeze feature on the block device level is needed
because the writing for the mmap()'ed file is suspended on
the frozen filesystem.

Any comments are very welcome.

Cheers, Takashi 
