From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Mon, 11 Aug 2014 22:40:38 +0800
Message-ID: <CAPTn0cCh0fh2REPgyXg_nBrJVVppiujVyj6XKruocg1q7MVVVA@mail.gmail.com>
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
Received: from mail-ie0-f181.google.com ([209.85.223.181]:64759 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbaHKOkj (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 11 Aug 2014 10:40:39 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> But since you've been arguing that the project id should get preserved
> across renames, they can evade quota usage by doing:
>
>          touch /product/mail/huge_file
>          mv  /product/mail/huge_file /product/maps
I don't really understand why these commands can evade project quota
since:
1) A newly created file will inherit project ID from its parent inode.
2) Project ID will be preserved across renames
3) Project quota won't be transfered unless its project ID is changed.
4) Only root user has the right to change project ID.
The rule 2) and 3) are just the same sematics with UID/GID quotas.
So, becasue of rule 1), after 'touch /product/mail/huge_file', the project
ID of 'huge_file' is 'mail', and its usage is accouted as project 'mail'.
Even we do 'mv /product/mail/huge_file /product/maps', because
of rule 2), there is no project ID updating and no quota transfer. Since
so, the project quota of file 'huge_file' is always accounted as 'mail',
from the first beginning to the end. And that is why I think project quota
of 'mail' can't be evaded in this way.

According to the discription of Jan Kara, I think the current implementation
of project quota support for ext4 is just a subset of XFS project quota, i.e.
project quota without XFS_DIFLAG_PROJINHERIT flag. I would like to
add such kind of flag for sure.

Regards,
Li Xi
