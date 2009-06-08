From: Jan Kara <jack@suse.cz>
Subject: Re: EXT3: filename duplicates
Date: Mon, 8 Jun 2009 20:49:40 +0200
Message-ID: <20090608184940.GB3046@atrey.karlin.mff.cuni.cz>
References: <Pine.LNX.4.62.0906042111550.22287@tamago.serverit.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Szabolcs Szakacsits <szaka@ntfs-3g.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:52739 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbZFHSti (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 8 Jun 2009 14:49:38 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0906042111550.22287@tamago.serverit.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

> When testing file creation performance we noticed that sometimes ext3 
> getdents64(2) lists some files twice. For instance after creating 
> filesnames from 1 to 1000000 in an empty directory:
> 
>  find | grep ./976253
>  ./976253
>  ./976253
> 
> This is 100% reproducible. Kernel is 2.6.25.5, x86_64.
> 
> Sorry if this was already known and fixed (couldn't find relevant info in 
> the archives, changelogs).
  2.6.28 and newer kernels should have this bug fixed.

									Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
