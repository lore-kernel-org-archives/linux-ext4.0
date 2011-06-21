From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: can we simplify the quota matrix in ext4?
Date: Tue, 21 Jun 2011 15:06:04 -0600
Message-ID: <07D034A6-BA0F-4643-87AF-C8BA3517A9E9@dilger.ca>
References: <4E00E6DE.9060208@redhat.com> <4E0105FD.9090401@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:56184 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab1FUVGH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 21 Jun 2011 17:06:07 -0400
In-Reply-To: <4E0105FD.9090401@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-06-21, at 2:58 PM, Eric Sandeen wrote:
> On 6/21/11 1:45 PM, Eric Sandeen wrote:
>> I was looking at 
>> 
>> 62d2b5f2dcd3707b070efb16bbfdf6947c38c194 ext4: Always journal quota file modifications
>> 
>> and was thinking - if we always journal, why do we still have all the mount options etc for journaled quota?
>> 
>> I guess without -o usrjquota=foo we don't journal right from mount time, and there are a few other paths that get skipped, but those seem like details...
>> 
>> It seems that ideally - and perhaps this is hindsight - ext4 should have defaulted to journaled, QFMT_VFS_V1 quotas only... is there any reason not to?
>> 
>> I'm still not very well versed in vfs quota, but does it seem possible to move in this direction?  It seems odd that we should still be supporting unjournaled, vfsold-format quotas in ext4 these days.  What's the point?
>> 
>> If it seems possible to move in this direction within the exiting quota framework I'd be interested in trying to get it done.
> 
> I was hoping that perhaps newer quota tools would only write newer quota formats to a fresh filesystem, and that would make things simpler, since only newer quota tools can understand ext4 in any case.
> 
> Sadly, no: "quotacheck -F vfsold" will happily write the old format quota file on an ext4 filesystem, even if that's not the default it'd choose.
> 
> So I guess a deprecation period would need to be endured on the formats.
> 
> And without knowing the format in use, we can't know the quota filename(?) so we can't do journaled quota on mount, either, I think, at least without the -o jqfmt=blah?  Unless we look up both quota.user and aquota.user?  But what if both are there?  Bleah.

I believe there are reserved fields in the superblock for the quota inodes.
It would be possible to save the inode numbers into those fields the first
time that the filesystem is mounted with a new kernel and/or run with a new
e2fsck, even if ext4 still leaves those files in existence.


Cheers, Andreas





