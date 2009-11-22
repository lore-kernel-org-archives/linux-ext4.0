From: Alexey Fisher <bug-track@fisher-privat.net>
Subject: Re: [PATCH v2] Unify log messages in ext3
Date: Sun, 22 Nov 2009 20:42:49 +0100
Message-ID: <1258918969.4529.2.camel@zwerg>
References: <4B087DEC.5010402@redhat.com>
	 <1258918735-4496-1-git-send-email-bug-track@fisher-privat.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Eric Sandeen <sandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>, linux-ext4@vger.kernel.org,
	Theodore Tso <tytso@mit.edu>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:47774 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753234AbZKVTnI (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Nov 2009 14:43:08 -0500
In-Reply-To: <1258918735-4496-1-git-send-email-bug-track@fisher-privat.net>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Sonntag, den 22.11.2009, 20:38 +0100 schrieb Alexey Fisher:
> make messages produced by ext3 more unified. It should be
> easy to parse.
> 
> dmesg before patch:
> [ 4893.684892] reservations ON
> [ 4893.684896] xip option not supported
> [ 4893.684964] EXT3-fs warning: maximal mount count reached, running
> e2fsck is recommended

I added some changes from Andis patch, so it up to date with git master.
I hope this patch will not be lost ;)
Regards,
	Alexey

