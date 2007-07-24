From: Theodore Tso <tytso@mit.edu>
Subject: Re: [Patch 8/13] Config before command line.
Date: Tue, 24 Jul 2007 10:41:57 -0400
Message-ID: <20070724144157.GD11826@thunk.org>
References: <1185275102.3789.73.camel@dhcp4.linsyssoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Andreas Dilger <adilger@clusterfs.com>
To: Girish Shilamkar <girish@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from thunk.org ([69.25.196.29]:38573 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750704AbXGXOmA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 24 Jul 2007 10:42:00 -0400
Content-Disposition: inline
In-Reply-To: <1185275102.3789.73.camel@dhcp4.linsyssoft.com>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Jul 24, 2007 at 04:35:02PM +0530, Girish Shilamkar wrote:
> The patch changes the order that the config file and command line are parsed so
> that command line has precedence.  

#1)  Could you please wrap your patch headers at about coulmn 72 or so,
please?  Thanks!!

#2) Changing when the config file is parsed doesn't change whether the
command line or the config file has precendence.  Parsing the config
file merely sets up an in-memory parse tree so that C code can query
the contents of the config file, e.g.:

	profile_get_boolean(ctx->profile, "options",
			    "defer_check_on_battery", 0, 1, 
			    &defer_check_on_battery);

Simply moving the profile_init() makes no difference.  Also, none of
the parameters in /etc/e2fsck.conf overlap with what you can specify
on the command-line, so I'm not even sure what the original author
(Jim Garlick) was even trying to get at.

> It also adds a check to make sure only one -E
> option is passed on the command line as -E option parsing is not cumulative.

Yep, this is reasonable.

					- Ted
