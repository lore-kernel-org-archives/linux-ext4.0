From: Andreas Dilger <adilger@sun.com>
Subject: Re: ext3 default journal mode
Date: Mon, 20 Jul 2009 17:36:20 -0600
Message-ID: <20090720233620.GC4231@webber.adilger.int>
References: <4A63DB89.2060306@redhat.com> <20090720212904.GI2416@mit.edu>
 <20090720230402.GB26687@shell>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: Theodore Tso <tytso@mit.edu>, Ric Wheeler <rwheeler@redhat.com>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"Stephen C. Tweedie" <sct@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <jbacik@redhat.com>, Mingming Cao <cmm@us.ibm.com>
To: Valerie Aurora <vaurora@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:59630 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbZGTXgz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 20 Jul 2009 19:36:55 -0400
Received: from fe-sfbay-09.sun.com ([192.18.43.129])
	by sca-es-mail-1.sun.com (8.13.7+Sun/8.12.9) with ESMTP id n6KNar4w014517
	for <linux-ext4@vger.kernel.org>; Mon, 20 Jul 2009 16:36:54 -0700 (PDT)
Content-disposition: inline
Received: from conversion-daemon.fe-sfbay-09.sun.com by fe-sfbay-09.sun.com
 (Sun Java(tm) System Messaging Server 7u2-7.02 64bit (built Apr 16 2009))
 id <0KN300600THPH400@fe-sfbay-09.sun.com> for linux-ext4@vger.kernel.org; Mon,
 20 Jul 2009 16:36:53 -0700 (PDT)
In-reply-to: <20090720230402.GB26687@shell>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Jul 20, 2009  19:04 -0400, Valerie Aurora wrote:
> I think it's extremely accurate and detailed, but too long - people's
> brains turn off after about the 15th line or so.  Here's an attempt to
> distill your description down and refer out to another document (which
> one?) for people who want to learn more.
> 
> (Sorry for the whitespace damage.)
> 
> -VAL
> 
>  config EXT3_DEFAULTS_TO_ORDERED
>  	bool "Default to 'data=ordered' in ext3"
>  	depends on EXT3_FS
>  	help
> 
>           If the mount options for an ext3 filesystem do not
>           include a journal mode, mount it in "data=ordered" mode.

I would make this a bit more clear:

            This option sets the default journal mode for ext3 filesystems
	    which do not explicitly specify it in /etc/fstab or at mount
	    time.  It is always possible to set the journal mode for each
	    filesystem independently with "data=writeback", "data=ordered",
	    or "data=journal" mount options.

>           The journal mode options for ext3 have different tradeoffs
>           between when data is guaranteed to be on disk and
>           performance.  Many applications assume "data=ordered"
>           semantics and may lose, destroy, or reveal other user's data
>           in other journal modes.  However, "data=ordered" mode can
>           also result in major performance problems, including long
>           delays before an fsync() call returns.  For details, see:

I think the "... lose, destroy, ..." part is confusing, as it mentions
"data=ordered" first and it isn't until the end of the sentence that
it is clear that "lose, destroy, ..." does not apply to data=ordered.
Also "data=journal" also does not apply in this case, only "data=writeback"
so we may as well call that out explicitly.

            ...  Many applications do not explicitly sync data and assume
	    "data=ordered" mode.  Saying 'N' here will use "data=writeback"
	    as the default for all ext3 filesystems, and may result in
	    files with no data, or garbage data from deleted files,
	    which is a security risk on a multi-user system.  However, ...

> 	  XXX some document
> 
> 	  Use "data=ordered" mode unless you know it is causing a
> 	  performance problem for your workload.
> 
>           If you are unsure, say 'Y'.

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

