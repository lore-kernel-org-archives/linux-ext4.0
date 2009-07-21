From: Theodore Tso <tytso@mit.edu>
Subject: Re: ext3 default journal mode
Date: Mon, 20 Jul 2009 22:00:50 -0400
Message-ID: <20090721020050.GK2416@mit.edu>
References: <4A63DB89.2060306@redhat.com> <20090720212904.GI2416@mit.edu> <20090720230402.GB26687@shell>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ric Wheeler <rwheeler@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Stephen C. Tweedie" <sct@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <jbacik@redhat.com>, Mingming Cao <cmm@us.ibm.com>
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from THUNK.ORG ([69.25.196.29]:37234 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbZGUCA4 (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jul 2009 22:00:56 -0400
Content-Disposition: inline
In-Reply-To: <20090720230402.GB26687@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Mon, Jul 20, 2009 at 07:04:03PM -0400, Valerie Aurora wrote:
> On Mon, Jul 20, 2009 at 05:29:04PM -0400, Theodore Tso wrote:
> > Here's a revised proposal for the KCONFIG text.  
> > 
> > Hopefully this is balanced about the two sides of the issue, without
> > explicitly advocating for one choice versus another.
> > 
> > What do people think?
> 
> I think it's extremely accurate and detailed, but too long - people's
> brains turn off after about the 15th line or so.  Here's an attempt to
> distill your description down and refer out to another document (which
> one?) for people who want to learn more.

Fair enough;  I've created an external document here:

http://ext4.wiki.kernel.org/index.php/Ext3_Data%3DOrdered_vs_Data%3DWriteback_mode

Comments?

>  config EXT3_DEFAULTS_TO_ORDERED
>  	bool "Default to 'data=ordered' in ext3"
>  	depends on EXT3_FS
>  	help
> 
>           If the mount options for an ext3 filesystem do not
>           include a journal mode, mount it in "data=ordered" mode.

Let me give a try at this:

           The journal mode options for ext3 have different tradeoffs
           between when data is guaranteed to be on disk and
           performance.  The use of "data=writeback" can cause
           unwritten data to appear in files after an system crash or
           power failure, which can be a security issue.  However,
           "data=ordered" mode can also result in major performance
           problems, including seconds-long delays before an fsync()
           call returns.  For details, see:

	   http://ext4.wiki.kernel.org/index.php/Ext3_Data%3DOrdered_vs_Data%3DWriteback_mode

          If you have been historically happy with ext3's performance,
          data=ordered mode will be a safe choice and you should
          answer "y" here.  If you understand the reliability and data
          privacy issues of data=writeback and are willing to make
          that trade off, answer "n".
	   
						- Ted
