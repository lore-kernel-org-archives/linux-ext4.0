From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [LSF/MM TOPIC] Drop ext2/ext3 codebase? When?
Date: Fri, 4 Feb 2011 10:36:21 -0700
Message-ID: <316721F8-70CD-4E29-A94E-BFEF2D762829@dilger.ca>
References: <20110203144011.GA28409@quack.suse.cz> <4D4AC4E2.701@redhat.com> <20110204130313.GB4104@quack.suse.cz>
Mime-Version: 1.0 (iPhone Mail 8C148a)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Eric Sandeen <sandeen@redhat.com>, Jan Kara <jack@suse.cz>,
	"lsf-pc@lists.linuxfoundation.org" <lsf-pc@lists.linuxfoundation.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:46626 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab1BDRg2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 4 Feb 2011 12:36:28 -0500
In-Reply-To: <20110204130313.GB4104@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-04, at 6:03, Jan Kara <jack@suse.cz> wrote:
>> I think that ext4 with nodelalloc should mostly mimic ext3 in those
>> cases, no?
>  Yeah, mostly. The biggest obstacle I see here is the different behavior
> of mmap - with nodelalloc allocation happens at the time of page fault and
> that fragments the file like hell for some kinds of load. Since ext3 here
> essentially does delayed allocation, it might be useful to do delayed
> allocation only from page fault path when we try to mimic ext3 behavior.
> So mimicking ext3 is possible but needs some tweaks...

The question is whether we need to mimic the runtime behavior or just the on-disk format?  Apps already need to deal with ext4 and other fs that do not do ext3 ordered mode. 

>> If we can have a real plan for moving in this direction though, I'd
>> support it.  I'm just not sure how we get enough real testing under
>> our belts to be comfortable with dropping ext[23], especially as
>> most distros now default to ext4 anyway.
>  Well, I believe this actually works for us. If the real users move to
> ext4 (or a different fs), then it's easier to make ext[23] mode in ext4
> good enough for the few legacy users...

I think the best road forward is to make ext4 the default for ext2 and ext3 filesystems in newer kernels, and mark ext2 and ext3 obsolete. This will start to get usage and testing of these other config options. The ext2 mode is already heavily tested at Google, and don't they also test noextent mode on updated filesystems, or were all of the filesystems reformatted with ext4 options?

After some number of kernel releases with ext4 as the default, we could remove the ext2 and ext3 code. 

Cheers, Andreas. 