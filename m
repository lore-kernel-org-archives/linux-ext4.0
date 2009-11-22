From: Alexey Fisher <bug-track@fisher-privat.net>
Subject: Re: [PATCH v1] Unify log messages in ext3
Date: Sun, 22 Nov 2009 20:12:56 +0100
Message-ID: <1258917176.4139.1.camel@zwerg>
References: <1258799115-10704-1-git-send-email-bug-track@fisher-privat.net>
	 <4B087DEC.5010402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Andreas Dilger <adilger@sun.com>,
	linux-ext4@vger.kernel.org, Theodore Tso <tytso@mit.edu>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41008 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753430AbZKVTM6 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Sun, 22 Nov 2009 14:12:58 -0500
In-Reply-To: <4B087DEC.5010402@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Am Samstag, den 21.11.2009, 17:55 -0600 schrieb Eric Sandeen:
> Alexey Fisher wrote:
> > make messages produced by ext3 more unified. It should be
> > easy to parse.
> 
> Didn't Andi Kleen send this change already way back on 4/26/09?
> 
> [PATCH] EXT3: Change all super.c messages to print the device
> 
> Not sure what happened to it ...
> 
> -Eric

Hmm... seems like Andis patch is against 2.6.30. I'll compare this two
patches.
	Alexey

