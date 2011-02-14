From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH][RFC] ext4: avoid taking down_read(&grp->alloc_sem)
Date: Mon, 14 Feb 2011 09:30:08 -0700
Message-ID: <2D97EC87-86D8-41D9-8779-BB4A48E60E89@dilger.ca>
References: <AANLkTimUmo5v14oKodaBKFtZPEHHuR9kZS5OSVtEFj2c@mail.gmail.com> <AANLkTimgCcW0fQzQ3W=vhkTSWt=0=xPoaBucrM=mfHXG@mail.gmail.com>
Mime-Version: 1.0 (iPhone Mail 8C148a)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Theodore Tso <tytso@mit.edu>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
	Ext4 Developers List <linux-ext4@vger.kernel.org>
To: "Amir G." <amir73il@users.sourceforge.net>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:12115 "EHLO
	idcmail-mo1so.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab1BNQaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 14 Feb 2011 11:30:10 -0500
In-Reply-To: <AANLkTimgCcW0fQzQ3W=vhkTSWt=0=xPoaBucrM=mfHXG@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2011-02-14, at 0:52, "Amir G." <amir73il@users.sourceforge.net> wrote:
>> @@ -1160,7 +1160,15 @@ ext4_mb_load_buddy(struct super_block *sb,
>> 
>> +       /*
>> +        * We only need to take the read lock if other groups share the buddy
>> +        * page with this group or if blocks may be added to this (last) group
>> +        * by ext4_group_extend().
>> +        */
>> +       if (blocks_per_page > 2 || group == sbi->s_groups_count - 1)
>> +               e4b->alloc_semp = &grp->alloc_sem;

No comment on whether this change is safe or not, but shouldn't this check be:

        if (blocks_per_page > 1 ||

Cheers, Andreas