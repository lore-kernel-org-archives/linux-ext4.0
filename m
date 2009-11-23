From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: ext4+quota patch series
Date: Mon, 23 Nov 2009 13:35:04 -0600
Message-ID: <4B0AE3E8.1020907@redhat.com>
References: <87my2d5ctb.fsf@openvz.org> <4B0AD154.7070201@redhat.com> <87ljhxxd6f.fsf@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Dmitry Monakhov <dmonakhov@openvz.org>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10304 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508AbZKWTfB (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 23 Nov 2009 14:35:01 -0500
In-Reply-To: <87ljhxxd6f.fsf@openvz.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Dmitry Monakhov wrote:
> Eric Sandeen <sandeen@redhat.com> writes:
>> Can you share those quota tests?  I'd love to put them into the xfstests
>> suite we've been using for ext4 as well.
> 
> write-truncate-chown: test delalloc + quota_transfer
> I've written crappy quotactl for quota manipulation
> (which i use for ct-tree-quota development).Some times
> it more useful. See files attached.

Great, thanks!

-Eric


> mkfs.ext4 /dev/sdb5 -b4096
> mount /dev/sdb5 /mnt -ogrpquota,usrquota
> quotacheck -cug /mnt
> # sync is necessary, because files may have reserved some blocks
> # which later lead to complain from claim_reserved_space
> # Probably we have print *huge* warning if we found
> # file with reserved blocks inodes traversing on quotaon 
> sync;sync;sync
> # turn on quota
> ./quotactl --all --on --device=/dev/sdb5 --path /mnt
> # run test
> ./write-truncate-chown /mnt/ 9999999999&
> # get quota report, print warn in case of incorrect quota.
> ./quotactl --all --get --type 0 --device=/dev/sdb5 || echo "failed"
> # checkout dmesg
> dmesg
> 
> 

