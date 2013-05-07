From: Radek Pazdera <rpazdera@redhat.com>
Subject: Re: [PATCH 0/3] e2fsprogs: Adding itree feature/inode flags
Date: Tue, 7 May 2013 14:47:28 +0200
Message-ID: <20130507124728.GA15311@laptop.redhat.com>
References: <1367703310-3842-1-git-send-email-rpazdera@redhat.com>
 <0BDEFE5C-3E54-4CEB-A94A-F35FEF593EDE@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"lczerner@redhat.com" <lczerner@redhat.com>,
	"kasparek@fit.vutbr.cz" <kasparek@fit.vutbr.cz>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758067Ab3EGMre (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Tue, 7 May 2013 08:47:34 -0400
Content-Disposition: inline
In-Reply-To: <0BDEFE5C-3E54-4CEB-A94A-F35FEF593EDE@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sat, May 04, 2013 at 09:24:48PM -0600, Andreas Dilger wrote:
>Could you please include some description of what "ITREE" is in the commit comments. 

Oh, that's right, there should be some description with these patches as
well. I'll add it there and repost them.

Thanks!

-Radek

>Cheers, Andreas
>
>On 2013-05-04, at 15:35, Radek Pazdera <rpazdera@redhat.com> wrote:
>
>> Hi,
>> 
>> This very short series that adds the itree flags to e2fsprogs mke2fs
>> and tune2fs in case someone would like to try the itree patches.
>> 
>> -Radek
>> 
>> Radek Pazdera (3):
>> libext2fs: Adding itree feature flag
>> libext2fs: Adding inode flag for itree
>> mke2fs, tune2fs: Adding support for the itree flag
>> 
>> lib/e2p/feature.c    | 2 ++
>> lib/e2p/pf.c         | 1 +
>> lib/ext2fs/ext2_fs.h | 2 ++
>> misc/mke2fs.c        | 3 ++-
>> misc/tune2fs.c       | 6 ++++--
>> 5 files changed, 11 insertions(+), 3 deletions(-)
>> 
>> -- 
>> 1.7.11.7
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
