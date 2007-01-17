From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] [RFC] remove ext3 inode from orphan list when link and
 unlink race
Date: Wed, 17 Jan 2007 16:47:37 -0600
Message-ID: <45AEA789.20407@redhat.com>
References: <45A7F384.3050303@redhat.com> <20070117224304.GM5236@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40519 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750971AbXAQWsL (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Wed, 17 Jan 2007 17:48:11 -0500
To: Andreas Dilger <adilger@clusterfs.com>
In-Reply-To: <20070117224304.GM5236@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Jan 12, 2007  14:45 -0600, Eric Sandeen wrote:
>> p.s. ext3_inc_count and ext3_dec_count seem misnamed, have an unused
>> arg, and are very infrequently called.  I'll probably submit a patch
>> to just put the single line of code into the caller, too.
> 
> I use those functions in the > 32000 subdirs patch to handle the case
> where a directory overflows the i_nlinks counter and needs to be set
> to have i_nlinks = 1.
> 
> Patch was posted previously, but rejected because there is a potential
> for directory loss if the filesystem is mounted on an older kernel
> (i_nlinks == 1, subdir is removed, directory is truncated).  I need to
> add an ROCOMPAT feature in order to handle this, but haven't gotten
> around to doing it.

Ah, ok.  Sorry I'd missed that.  Can we at least rename them to
something that makes sense? :)

-Eric

> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 
