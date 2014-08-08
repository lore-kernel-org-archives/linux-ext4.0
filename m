From: Li Xi <pkuelelixi@gmail.com>
Subject: Re: [PATCH v2 0/4] quota: add project quota support
Date: Sat, 9 Aug 2014 00:58:18 +0800
Message-ID: <CAPTn0cB=gj=vmMt0eG2pvJEEMTE6n+WQ6w7VXLgov0g0U6=RVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-fsdevel@vger.kernel.org,
	Ext4 Developers List <linux-ext4@vger.kernel.org>,
	viro@zeniv.linux.org.uk, hch@infradead.org, Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:43879 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbaHHQ6T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 8 Aug 2014 12:58:19 -0400
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Sorry, please ignore the wrong patch summary in the end of my last
email. Following is the right one:

 Documentation/filesystems/ext4.txt |    4 +
 fs/ext4/ext4.h                     |   19 +++++-
 fs/ext4/ialloc.c                   |    4 +
 fs/ext4/inode.c                    |   80 +++++++++++++++++++++++-
 fs/ext4/ioctl.c                    |  100 +++++++++++++++++++++++++++++
 fs/ext4/super.c                    |   77 +++++++++++++++++++---
 fs/quota/Kconfig                   |    9 +++
 fs/quota/dquot.c                   |  123 ++++++++++++++++++++++++++++--------
 fs/quota/quota.c                   |    5 +-
 fs/quota/quotaio_v2.h              |    6 +-
 include/linux/quota.h              |    9 +++
 include/uapi/linux/quota.h         |    6 +-
 12 files changed, 398 insertions(+), 44 deletions(-)
