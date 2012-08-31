From: Jan Kara <jack@suse.cz>
Subject: Re: ext4 hung tasks in linux-stable 3.0.41
Date: Fri, 31 Aug 2012 11:28:59 +0200
Message-ID: <20120831092859.GB19786@quack.suse.cz>
References: <50406B29.1090403@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
	Theodore Tso <tytso@MIT.EDU>, adilger.kernel@dilger.ca,
	linux-ext4@vger.kernel.org
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55522 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab2HaJ3C (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 31 Aug 2012 05:29:02 -0400
Content-Disposition: inline
In-Reply-To: <50406B29.1090403@profihost.ag>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

  Hello,

On Fri 31-08-12 09:43:37, Stefan Priebe - Profihost AG wrote:
> i'm expected every night a hang of my rsync backup process, doing a
> backup to an ext4 filesystem. Always throwing Call traces.
> 
> The hung task messages are really long so i posted it to pastebin:
> http://pastebin.com/raw.php?i=9v7HEvjA
> 
> Used kernel: vanilla 3.0.41
> 
> Is this problem known? Or is there a fix for 3.0.X available?
  From a quick look, processes are waiting for IO so it may be that your
disk is just loaded... Did it start happening after some change? Or do you
experience unexpectedly low performance?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
