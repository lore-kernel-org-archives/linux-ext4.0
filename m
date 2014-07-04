From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] Move e2fsprogs-specific macros from aclocal.m4 to
 acinclude.m4
Date: Fri, 4 Jul 2014 08:35:13 -0400
Message-ID: <20140704123513.GD10514@thunk.org>
References: <1404211654-10158-1-git-send-email-ross.burton@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4@vger.kernel.org
To: Ross Burton <ross.burton@intel.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:45096 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbaGDMfQ (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 4 Jul 2014 08:35:16 -0400
Content-Disposition: inline
In-Reply-To: <1404211654-10158-1-git-send-email-ross.burton@intel.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jul 01, 2014 at 11:47:34AM +0100, Ross Burton wrote:
> Autoconf says that aclocal.m4 is a machine-generated copy of system-wide macros,
> whereas acinclude.m4 is for project-specific macros.  Reflect this division and
> ease building by anyone who needs to re-generate the autotooling by splitting
> AX_TLS and CHECK_GNU_MAKE to acinclude.m4.
> 
> Signed-off-by: Ross Burton <ross.burton@intel.com>

Applied, thanks.

						- Ted
