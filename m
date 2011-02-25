From: Marco Stornelli <marco.stornelli@gmail.com>
Subject: Re: [RFC][PATCH] ext2: Resolve i_nlink race in ext2_rename
Date: Fri, 25 Feb 2011 08:38:15 +0100
Message-ID: <AANLkTikmgaoBsf5neCxM9jYCJGkdAS1QC2k0zKUTW2=8@mail.gmail.com>
References: <1298528501-32176-1-git-send-email-johunt@akamai.com>
	<20110224063749.GV22723@ZenIV.linux.org.uk>
	<20110224112010.GB23042@quack.suse.cz>
	<4D66BD18.2030207@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Jan Kara <jack@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
	"linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"sandeen@redhat.com" <sandeen@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
To: Josh Hunt <johunt@akamai.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:54742 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755404Ab1BYHiQ (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 25 Feb 2011 02:38:16 -0500
In-Reply-To: <4D66BD18.2030207@akamai.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

2011/2/24 Josh Hunt <johunt@akamai.com>:
> Jan
>
> I'm not seeing the problem with your patch as was expected since we're
> not messing with i_nlink anymore. Al suggested marking the inode as
> dirty where we were previously doing the old_inode dec. I believe this
> is needed as well since we are updating it's ctime. I've attached a
> version marking the inode dirty and it also fixes the comment making
> reference to calling inode_dec_link_count().
>
> I'm not completely clear on the historical reasons for messing with the
> link count of old_inode in the first place. It was just to simulate the
> linking and unlinking of the old_inode?
>
> Thanks
> Josh
>

can we share your test/benchmark? I'd like to add it to my test suite
as no-regression test.

Marco
