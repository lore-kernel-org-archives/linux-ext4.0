From: Jan Kara <jack@suse.cz>
Subject: Re: how to quotacheck with the new quota implementation (hidden
 inode)?
Date: Mon, 4 Feb 2013 10:42:10 +0100
Message-ID: <20130204094210.GA7523@quack.suse.cz>
References: <20730.1955.395545.141779@fisica.ufpr.br>
 <20130121054741.GB321@thunk.org>
 <20746.49010.569691.44452@fisica.ufpr.br>
 <CAGr1F2F=mffm7PORykm2CbXt3EWt1=Zgerw-OEy7oGzUQ2dEQA@mail.gmail.com>
 <20746.49740.638811.698394@fisica.ufpr.br>
 <20130131220312.GA15322@thunk.org>
 <20130131222817.GB13525@quack.suse.cz>
 <20130131230330.GB15322@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, Carlos Carvalho <carlos@fisica.ufpr.br>,
	Aditya Kali <adityakali@google.com>,
	ext4 development <linux-ext4@vger.kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab3BDJmN (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 4 Feb 2013 04:42:13 -0500
Content-Disposition: inline
In-Reply-To: <20130131230330.GB15322@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Thu 31-01-13 18:03:30, Ted Tso wrote:
> On Thu, Jan 31, 2013 at 11:28:17PM +0100, Jan Kara wrote:
> >   What version of quota-tools are you using? If I didn't screw up
> > something, version 4.01 shouldn't need the -o quota mount option anymore...
> 
> Ah, I was using 4.00-4 from Debian Testing (which hopefully will soon
> be the new Debian Obsolete^H^H^H^H^H^H^H^H Stable).
> 
> I'll have to upgrade to a newer quota tools for my testing, but we
> should definitely note that users who want to use the internal quota
> needs to be using a newer quota-tools than what is shipping in Debian
> Stable, Debian Testing, Ubuntu Precise, etc.
> 
> Is there an easy way to find what version of quota-tools is being used
> in various versions of Fedora or OpenSuSE (I assume all of the
> enterprise distro's will have prehistoric softare, so I'm not even
> worrying about them :-).  This would be good information to put up on:
> 
>       https://ext4.wiki.kernel.org/index.php/Quota
  I don't know about Fedora but for openSUSE one can have a look at:
http://software.opensuse.org/package/quota
  There you see the version for the latest distro (12.2 - has version
4.00), if you click on "Show other versions", you can check the version in
older releases.

  Actually I can see there that openSUSE Factory still has 4.00 (so that
will end up in soon to be released 12.3) so I have to ping our quota
packager to update.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
