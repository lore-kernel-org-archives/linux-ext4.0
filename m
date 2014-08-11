From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Mon, 11 Aug 2014 08:06:41 +0800
Message-ID: <CAPTn0cDSyvA15k+3BGgWtG2hfrS0zkb75=NYhfgPt5pvANTMCg@mail.gmail.com>
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
Received: from mail-ig0-f181.google.com ([209.85.213.181]:50447 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaHKAGm (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sun, 10 Aug 2014 20:06:42 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> This being said, for this particular use case, I'm not entirely sure
> why you can't just create separate groups for each project, and then
> let group inheritance take care of things:
>
> mkdir top-level
> chgrp project1 top-level
> chmod g+s top-level
>
> Now all of the files created in top-level will be accounted in
> project1's quota.
>
> If the answer is that it's too easy to evade quota controls by using
> the "chgrp" command, note that if you are going to allow users to mv
> files around, they can easily evade the project quota anyway, by
> creating the file in top-level dirctory of project2, and then mv'ing
> it into the top-level directory of project1.
Yeah, we don't want common users to change the project ID of thier
files, so setting project is only allowed for administrator in this
implementation. And since project ID of an inode won't be changed
when it is renamed around, common users has no way to evade
project quota.

Regards,
                                          -Li Xi
