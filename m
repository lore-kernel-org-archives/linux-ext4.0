From: Valerie Aurora <vaurora@redhat.com>
Subject: Re: ext3 default journal mode
Date: Mon, 20 Jul 2009 19:04:03 -0400
Message-ID: <20090720230402.GB26687@shell>
References: <4A63DB89.2060306@redhat.com> <20090720212904.GI2416@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Stephen C. Tweedie" <sct@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <jbacik@redhat.com>, Mingming Cao <cmm@us.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40237 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbZGTXGL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jul 2009 19:06:11 -0400
Content-Disposition: inline
In-Reply-To: <20090720212904.GI2416@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 20, 2009 at 05:29:04PM -0400, Theodore Tso wrote:
> Here's a revised proposal for the KCONFIG text.  
> 
> Hopefully this is balanced about the two sides of the issue, without
> explicitly advocating for one choice versus another.
> 
> What do people think?

I think it's extremely accurate and detailed, but too long - people's
brains turn off after about the 15th line or so.  Here's an attempt to
distill your description down and refer out to another document (which
one?) for people who want to learn more.

(Sorry for the whitespace damage.)

-VAL

 config EXT3_DEFAULTS_TO_ORDERED
 	bool "Default to 'data=ordered' in ext3"
 	depends on EXT3_FS
 	help

          If the mount options for an ext3 filesystem do not
          include a journal mode, mount it in "data=ordered" mode.

          The journal mode options for ext3 have different tradeoffs
          between when data is guaranteed to be on disk and
          performance.  Many applications assume "data=ordered"
          semantics and may lose, destroy, or reveal other user's data
          in other journal modes.  However, "data=ordered" mode can
          also result in major performance problems, including long
          delays before an fsync() call returns.  For details, see:

	  XXX some document

	  Use "data=ordered" mode unless you know it is causing a
	  performance problem for your workload.

          If you are unsure, say 'Y'.
