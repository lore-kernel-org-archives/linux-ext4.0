From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: [PATCH 0/3] e2fsprogs: Adding itree feature/inode flags
Date: Sat, 4 May 2013 21:24:48 -0600
Message-ID: <0BDEFE5C-3E54-4CEB-A94A-F35FEF593EDE@dilger.ca>
References: <1367703310-3842-1-git-send-email-rpazdera@redhat.com>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
	"lczerner@redhat.com" <lczerner@redhat.com>,
	"kasparek@fit.vutbr.cz" <kasparek@fit.vutbr.cz>,
	Radek Pazdera <rpazdera@redhat.com>
To: Radek Pazdera <rpazdera@redhat.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:63452 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3EEDYt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Sat, 4 May 2013 23:24:49 -0400
Received: by mail-pd0-f173.google.com with SMTP id v10so1488152pde.18
        for <linux-ext4@vger.kernel.org>; Sat, 04 May 2013 20:24:48 -0700 (PDT)
In-Reply-To: <1367703310-3842-1-git-send-email-rpazdera@redhat.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Could you please include some description of what "ITREE" is in the commit comments. 

Cheers, Andreas

On 2013-05-04, at 15:35, Radek Pazdera <rpazdera@redhat.com> wrote:

> Hi,
> 
> This very short series that adds the itree flags to e2fsprogs mke2fs
> and tune2fs in case someone would like to try the itree patches.
> 
> -Radek
> 
> Radek Pazdera (3):
> libext2fs: Adding itree feature flag
> libext2fs: Adding inode flag for itree
> mke2fs, tune2fs: Adding support for the itree flag
> 
> lib/e2p/feature.c    | 2 ++
> lib/e2p/pf.c         | 1 +
> lib/ext2fs/ext2_fs.h | 2 ++
> misc/mke2fs.c        | 3 ++-
> misc/tune2fs.c       | 6 ++++--
> 5 files changed, 11 insertions(+), 3 deletions(-)
> 
> -- 
> 1.7.11.7
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
