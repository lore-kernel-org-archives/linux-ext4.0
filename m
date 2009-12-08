From: Jan Kara <jack@suse.cz>
Subject: Re: System hang with EXT4
Date: Tue, 8 Dec 2009 16:18:16 +0100
Message-ID: <20091208151816.GB3141@atrey.karlin.mff.cuni.cz>
References: <150c16850911231816t514bb1dds4deb541b14a5bad6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Justin Maggard <jmaggard10@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49591 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755989AbZLHPSK (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 8 Dec 2009 10:18:10 -0500
Content-Disposition: inline
In-Reply-To: <150c16850911231816t514bb1dds4deb541b14a5bad6@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hi,

> I've recently run into an issue with ext4 and delayed allocation where
> my system will silently hang just seconds into a dbench run.  I first
> saw this using 2.6.30.9, but it still happens with 2.6.32-rc8.  I've
> tried with an SMP x86_64 system, and a UP i386 system.  The SMP x86_64
> system hangs every time for me within 15 seconds, but the UP i386
> system never hangs on me.  If I remount with -o nodelalloc on the SMP
> system, the hang goes away.  There are no messages printed out by the
> kernel; it just locks hard.  Has anyone seen this before?  I'm just
> running "dbench 500" to produce this behavior.
  Can you still switch consoles after the system hangs (it's good to
debug this on a text console)? If yes, could you press Alt-Sysrq-w and
take a picture of the console by digital camera or so (take pictures of
as many screens as possible using console scrollback)? Thanks.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
