From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: ext3 default journal mode
Date: Mon, 20 Jul 2009 17:33:02 -0400
Message-ID: <4A64E28E.2000907@redhat.com>
References: <4A63DB89.2060306@redhat.com> <20090720212904.GI2416@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Valerie Aurora <vaurora@redhat.com>,
	"Stephen C. Tweedie" <sct@redhat.com>,
	Eric Sandeen <esandeen@redhat.com>,
	Andreas Dilger <adilger@sun.com>,
	Chris Mason <chris.mason@oracle.com>,
	Josef Bacik <jbacik@redhat.com>, Mingming Cao <cmm@us.ibm.com>
To: Theodore Tso <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:40352 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751402AbZGTVdT (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 20 Jul 2009 17:33:19 -0400
In-Reply-To: <20090720212904.GI2416@mit.edu>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 07/20/2009 05:29 PM, Theodore Tso wrote:
> Here's a revised proposal for the KCONFIG text.
>
> Hopefully this is balanced about the two sides of the issue, without
> explicitly advocating for one choice versus another.
>
> What do people think?
>
> 						- Ted


Hi Ted,

I think that this is a huge improvement - thanks!

Ric

>
> P.S.  Note that date=writeback does not make the filesystem more
> "prone to corruption after crashes".
>
>
> config EXT3_DEFAULTS_TO_ORDERED
> 	bool "Default to 'data=ordered' in ext3"
> 	depends on EXT3_FS
> 	help
> 	  If a filesystem does not explicitly specify a data ordering
> 	  mode, and the journal capability allowed it, ext3 used to
> 	  historically default to 'data=ordered'.
>
>            Data=ordered mode is the mode used by most distributions, but can
>            introduce latency problems in some workloads, especially if there
> 	  is a combination of high bandwidth background writes and foreground
> 	  processes calling fsync() and waiting for the result.   In worst
> 	  case scenarios, the fsync() call can 500ms to multiple seconds
> 	  to return.
>
> 	  The problem with using a default of data=writeback, however,
> 	  is that is that after a system crash or a power failure,
> 	  files that were written right before the system went down
> 	  could contain previously written data or other garbage.
> 	  With data=ordered mode, any blocks in the file will have
> 	  been data written by the application, avoiding a possibility
> 	  of a security breach, which is especially problematic on a
> 	  multi-user system.  Note, however, that data=ordered does
> 	  not guarantee that the file will be consistent at an
> 	  application level; the application must use fsync() at
> 	  appropriate commit points in order to guarantee
> 	  application-level consistency.
>
>            If you have been historically happy with ext3's performance,
>    	  data=ordered mode will be a safe choice and you should
>    	  answer "y" here.  If you understand the reliability and data
>    	  privacy issues of data=writeback and are willing to make
>    	  that trade off, answer "n".
>

