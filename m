From: Jan Kara <jack@suse.cz>
Subject: Re: Potential data consistency issue with ASYNC_COMMIT feature
Date: Wed, 16 Dec 2009 21:33:03 +0100
Message-ID: <20091216203303.GA28425@atrey.karlin.mff.cuni.cz>
References: <FA695DF7-1D78-471A-A527-0079C045AF09@linuxhacker.ru> <6375EE02-90AB-442B-B079-E44D0D0FC346@linuxhacker.ru> <20091211205254.GH31139@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Oleg Drokin <green@linuxhacker.ru>, linux-ext4@vger.kernel.org,
	Alex Zhuravlev <Alex.Zhuravlev@Sun.COM>,
	Andreas Dilger <adilger@Sun.COM>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60228 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbZLPUdH (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 16 Dec 2009 15:33:07 -0500
Content-Disposition: inline
In-Reply-To: <20091211205254.GH31139@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> However, journal checksums failed horribly when we tried to enable
> them by default during the last merge window, because of bugs in ext4
> where we were modifying certain metadata blocks (in particular
> superblock and xattr's) without journalling them.  (Note to self; we
> need to back port those fixes to ext3; the lack of journalling in
> xattr in particular could mean that in some cases we could lose some
> updates that could affect SELINUX after a crash.)
  Already done by Eric and merged ;): d965736b8cb42ae51ba9c3f13488035a98d025c6,
b918397542388de75bd86c32fbfa820e5d629fa9.

								Honza
-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
