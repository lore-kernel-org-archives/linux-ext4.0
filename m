From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Support a stateless configuration by default
Date: Mon, 8 Jun 2015 12:32:51 -0400
Message-ID: <20150608163251.GA4026@thunk.org>
References: <1432306620-6368-1-git-send-email-michael.i.doherty@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ikey Doherty <michael.i.doherty@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:53245 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100AbbFHQc4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 8 Jun 2015 12:32:56 -0400
Content-Disposition: inline
In-Reply-To: <1432306620-6368-1-git-send-email-michael.i.doherty@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, May 22, 2015 at 03:57:00PM +0100, Ikey Doherty wrote: With
> this change, distribution defaults are now read from the
> distribution defaults directory,
> /usr/share/defaults/e2fsprogs. These files are expected to be the
> sensible defaults required for basic operation.
> 
> Site administrators may still override the default configuration by
> placing the files within the site config directory (i.e. /etc) - and
> those configuration values will be read instead. The distribution
> files within the defaults directory are percieved as immutable, and
> as such resiliant to upgrades over time.
> 
> A side effect of this stateless configuration is that a site
> admiministrator is able to reset their configuration to the sane
> defaults by simply removing the files they placed within the site
> configuration directory.
> 
> To users already making use of an altered configuration within /etc,
> this change is transparent and does not affect existing operation.
> 
> The fundamental goal within this change, and stateless itself, is to
> separate OS configuration from the system administrator
> configuration.

I'm willing to take a patch which checks /usr/share/defaults/e2fsprogs
first, but not to install the config file instead of /etc/mke2fs.conf.
This is *not* yet the default, and the vast majority of Linux systems
are still using /etc/mke2fs.conf.  If a particular distribution wants
to use a diferent packaging scheme, that's fine, but until it's the
common case, I'm not going to break existing systems by changing the
default installation location.

That being said, it should also be noted that mke2fs will work just
fine without /etc/mke2fs.conf being present (we take the default
mke2fs.conf and create default_profile.o which gets used if the
default profile isn't present), and we currently don't ship a default
e2fsck.conf file.  So you really don't have to do anything special to
get the stateless setup that you desire.

						- Ted
