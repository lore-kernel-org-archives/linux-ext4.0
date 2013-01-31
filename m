From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: how to quotacheck with the new quota implementation (hidden
 inode)?
Date: Thu, 31 Jan 2013 18:03:30 -0500
Message-ID: <20130131230330.GB15322@thunk.org>
References: <20730.1955.395545.141779@fisica.ufpr.br>
 <20130121054741.GB321@thunk.org>
 <20746.49010.569691.44452@fisica.ufpr.br>
 <CAGr1F2F=mffm7PORykm2CbXt3EWt1=Zgerw-OEy7oGzUQ2dEQA@mail.gmail.com>
 <20746.49740.638811.698394@fisica.ufpr.br>
 <20130131220312.GA15322@thunk.org>
 <20130131222817.GB13525@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Carlos Carvalho <carlos@fisica.ufpr.br>,
	Aditya Kali <adityakali@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from li9-11.members.linode.com ([67.18.176.11]:46442 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab3AaXDf (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Thu, 31 Jan 2013 18:03:35 -0500
Content-Disposition: inline
In-Reply-To: <20130131222817.GB13525@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu, Jan 31, 2013 at 11:28:17PM +0100, Jan Kara wrote:
>   What version of quota-tools are you using? If I didn't screw up
> something, version 4.01 shouldn't need the -o quota mount option anymore...

Ah, I was using 4.00-4 from Debian Testing (which hopefully will soon
be the new Debian Obsolete^H^H^H^H^H^H^H^H Stable).

I'll have to upgrade to a newer quota tools for my testing, but we
should definitely note that users who want to use the internal quota
needs to be using a newer quota-tools than what is shipping in Debian
Stable, Debian Testing, Ubuntu Precise, etc.

Is there an easy way to find what version of quota-tools is being used
in various versions of Fedora or OpenSuSE (I assume all of the
enterprise distro's will have prehistoric softare, so I'm not even
worrying about them :-).  This would be good information to put up on:

      https://ext4.wiki.kernel.org/index.php/Quota

							- Ted
