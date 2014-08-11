From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Mon, 11 Aug 2014 18:23:53 +0800
Message-ID: <CAPTn0cBGU+bsBc6DumassOyw0HuDP2tAetFaoAOV4TFw21Ud4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Shuichi Ihara <sihara@ddn.com>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"hch@infradead.org" <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	Andreas Dilger <adilger@dilger.ca>,
	"Niu, Yawei" <yawei.niu@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:43630 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbaHKKXy (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2014 06:23:54 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

>
> Or are you really saying you really need to simultaneously track quota
> from a group perspective, and a project perspectively, at the same
> time?  If so, why?
An reason that we don't want to use group quota for project use case is that
we don't want to lose the track of the group usage that the user belongs
to. Let's assume GROUP1 has only two users, USER1 and USER2. Normally, we
want to query the disk usage of GROUP1 by 'quota -g GROUP1 -v'. The disk
usage should be the sum of 'quota -u USER1 -v' and 'quota -u USER2 -v', if
we never do any unusual chgrp/chown. But if we change the GID of files
created by USER1 to PROJECT1, there will be a mismatching between
'quota -g GROUP1 -v' and ('quota -u USER1 -v' + 'quota -u USER2 -v').

As mentioned by Ihara, project quota support for ext4 is an important
part of project quota support for Lustre. I'd like to explain a little
bit about the expecting usage of project quota for Lustre.

As a distributed file system, Lustre is able to use hundreds of seperate
ext4 file systems to store its data as well as metadata, yet provides a
united global name space. Some of users start to use SSD devices for better
performance on Lustre. However as we can expect, they might want to replace
only part of the drivers to SSD, since SSD is expensive. That means, part
of the ext4 file systems are using SSD and the other part of the ext4 file
systems are using hard disks. In the sight of Lustre, users can choose to
locate files on SSDs or hard disks using features of Lustre, namely 'stripe'
and 'OST pool'. Here comes the problem, how to limit the usage of SSD since
all end users want good performance badly?

Quota system is designed to allot such kind of limited resources. However,
unfortunately, former UID/GID based quotas won't help in this case. UID/GID
based quotas works well in alloting one determined kind of resource, i.e.
global space and inode usage. But when the resource itself have to be
devided to seperate parts either for management reasons (e.g. virtualization)
or physical reasons (e.g. SSD v.s. hard disk v.s. tape), UID/GID based quota
is not helping, simply because UID/GID is not a suitable way to distinguish
resources. That is why we need another dimension of quota.

Of course, we might be able to find some walk-around ways using group quota.
However, because the owners of the files can change the group attributes
freely, it is so easy for the users to evade the group quota and steal the
tight resources. For example, in order to steal SSD space, a user can just
creating the files using the sepcific group ID and then change it back.
And administrators can never expect users will cooperate on this. Users always
have enough excuses to ignore requirements from administrators to delete
unnecessary data on a shared file system, if there is no hard quota
limits on that system. In the current implementation of project quota,
project ID can only be changed by privileged users, so that won't be a
problem for it.

Thanks,
Li Xi
