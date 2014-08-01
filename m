From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH 0/4] quota: add project quota support
Date: Fri, 1 Aug 2014 23:48:31 +0800
Message-ID: <CAPTn0cD3eZgL1FaJLrgN-c_vhsvSoifmyLah=y60ejcAEOz-Mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:52644 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbaHAPsc (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 1 Aug 2014 11:48:32 -0400
Received: by mail-ig0-f182.google.com with SMTP id c1so1795772igq.15
        for <linux-ext4@vger.kernel.org>; Fri, 01 Aug 2014 08:48:31 -0700 (PDT)
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

2014-08-01 23:28 GMT+08:00 Li Xi <pkuelelixi@gmail.com>:
> 2014-08-01 20:40 GMT+08:00 Jan Kara <jack@suse.cz>:
>>
>> 1) It should have been also posted to linux-fsdevel@vger.kernel.org, Al Viro
>> <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org> because
>> you are changing core VFS inode and infrastructure as well. For quota
>> changes you should have also CCed me as a quota maintainer.
> Sure. Thanks for reminding me. I will add these addresses next time.
>>
>> 2) I'm not convinced we actually want project ID in the core inode - so far
>> only XFS has this. For everyone else it's just extra bloat so we could just
>> put it in ext4_inode_info. Granted we'd need to somewhat change quota
>> interface so that it sees all the ids (uid, gid, projid) but they are
>> really needed in two places - dquot_initalize() and dquot_transfer() and
>> creating variants of these functions that just take an array of ids and use
>> them in ext4 is simple enough.
> OK, agreed.
After searching dquot_initalize() and dquot_transfer(), I found changing these
two functions envolves too many file systems. Is there any good reason not to
add kprojid_t field in inode structure?
>>
>> 3) I see no way how to get / set project ID from userspace. Did I miss
>> something?
> Yeah, you are right. I didn't push the interface patch. We implemeted
> two kinds of interfaces. One is based on extended attribute interfaces which
> simulate project ID as an extended attribute of the inode. The other implemented
> a new ioctl command for ext4. Personally, I think ioctl is better. What is your
> opinion?
>>
>> 4) The ext4 change is changing on-disk format. You definitely need a
>> feature flag for that so that kernels that don't understand project quotas
>> don't corrupt the filesystem. Also you need a support for this in
>> e2fsprogs.
> Sure. I will add feature flag for project quota of ext4. And there are
> quite some
> related tools need updates, including e2fsprogs and quota-tools. We will push
> those patches as soon as they are ready.
>>
>> 5) You make the feature configurable both in quota code and ext4. I don't
>> think the footprint of the feature warrants that.
> Sure. Good point.
>
> Thank you for the advices, I will refresh the patches and send the mails to all
> of the related addresses soon.
>
> Regards,
> Li Xi
