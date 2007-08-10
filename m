From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [PATCH] dir_index: error out instead of BUG on corrupt hash dir
 limit
Date: Fri, 10 Aug 2007 13:39:49 -0500
Message-ID: <46BCB0F5.5060701@redhat.com>
References: <46BB8830.3060009@redhat.com> <46BB9826.6040904@redhat.com> <20070810082904.GL6689@schatzie.adilger.int> <46BC8D61.9080400@redhat.com> <20070810181901.GT6689@schatzie.adilger.int>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 development <linux-ext4@vger.kernel.org>
To: Andreas Dilger <adilger@clusterfs.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754930AbXHJSjw (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 10 Aug 2007 14:39:52 -0400
In-Reply-To: <20070810181901.GT6689@schatzie.adilger.int>
Sender: linux-ext4-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Andreas Dilger wrote:
> On Aug 10, 2007  11:08 -0500, Eric Sandeen wrote:
>> Andreas Dilger wrote:
>>> I'd like to see the actual corruption, to find out why the hash-type
>>> check didn't find it.  If it is because LDISKFS_DX_HASH_LEGACY hash
>>> type is zero, I think we can disable that hash type, and people will
>>> just have to run "e2fsck -fD" to reindex to a new type.  This hasn't
>>> been on for a long, long time.
>> So far I haven't been able to find it in any of the images provided.
>>
>> We may have to dual-boot windows & run the crummy driver for a while to
>> track it down, if we care enough.
>>
>> Which reminds me, what do you think of the wording in the ext3_warning I
>> added - is "corruption" appropriate?  The other warnings aren't quite so
>> stark... hmm maybe we should  add "have you been running a binary-only
>> driver for windows?"  :)
> 
> It would be interesting to check if mounting a dir_index filesystem on
> linux with ext2 has the same problem.  It _should_ have been that 
> if rec_len % 4 == 0 (i.e. any valid dirent) we would fail the hash_version
> check, but we left in the DX_HASH_LEGACY (0) and that check is blown.

Hmmm...

> The unused_flags & 1 is only hit for a dirent with DT_FIFO (no good).
> The remaining check is indirect_levels > 1, which should be hit for
> any dirent with name_len > 1 (i.e. most, but not all).
> 
> So, I think you could reproduce this in linux by making an indexed directory
> in ext3/4, mounting it as ext2, and then creating a 1-character filename
> in the directory, or any length filename and then deleting it.

With those quick tests I don't see any problems... you may be giving the
windows driver too much credit here.  :)

-Eric

> In addition to your extra check, I think we should remove DX_HASH_LEGACY
> check, to catch this more easily.  If (hash_version % 4 == 0) the warning
> shouldn't even be printed.
> 
> Cheers, Andreas
> --
> Andreas Dilger
> Principal Software Engineer
> Cluster File Systems, Inc.
> 
