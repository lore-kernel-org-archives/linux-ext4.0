From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] ext4/super.c: Replace CONTIG_EXT{2,3}_FS by CONFIG_EXT{2,3}_FS
Date: Wed, 24 Mar 2010 11:21:59 -0500
Message-ID: <4BAA3C27.2000505@redhat.com>
References: <2d0a357f1003240405x1178f0c6x188d30d1d311cb5@mail.gmail.com> <20100324161201.GG2159@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>
To: tytso@mit.edu
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36989 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab0CXQWE (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 24 Mar 2010 12:22:04 -0400
In-Reply-To: <20100324161201.GG2159@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 03/24/2010 11:12 AM, tytso@mit.edu wrote:
> Thanks for catching this!  This should fix it up...
> 
>        	   	    	   	       	   - Ted
> 
> ext4: Fix build error when EXT4_USE_FOR_EXT23 disabled
> 
> Fix a stupid type (CONTIG != CONFIG) and a stupid assumption that
> ext3_fs_type would always be defined.
> 
> (The build failure could also happen when EXT4_USE_FOR_EXT23 is
> enabled and ext3 is built as a module.)

A little late, but right now we have this in Kconfig:

config EXT4_USE_FOR_EXT23
        bool "Use ext4 for ext2/ext3 file systems"
        depends on EXT4_FS
        depends on EXT3_FS=n || EXT2_FS=n

do we really want "||" ?

so, if you turn off ext2, but leave ext3 on, it will ask you if you want
to use ext4 for ext3?  That doesn't make sense to me.

Shouldn't it be:

-        depends on EXT3_FS=n || EXT2_FS=n
+        depends on EXT3_FS=n && EXT2_FS=n

?

-Eric
