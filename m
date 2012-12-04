From: Prashant Shah <pshah.mumbai@gmail.com>
Subject: Re: freeze_bdev hangs
Date: Tue, 4 Dec 2012 18:40:33 +0530
Message-ID: <CAD6i1fK8bog1wo8E60qFb1piT8P3E=QoaaUH=qiys2R4jG3QPA@mail.gmail.com>
References: <CAD6i1f+fzh-z+Xr6V2gHBzq4kmJzPcfre91g=q6fJ7P_5nY0Zw@mail.gmail.com>
 <506F19E6.8030005@redhat.com> <CAD6i1fJbfiBnTu1ttisMr96PzaTWCLAsvmTjx7OevfPcAGd7-A@mail.gmail.com>
 <20121008161926.GH9243@quack.suse.cz> <CAD6i1fKpWZVbL4gS1ui7GvF81S+SAduckXeWoApwH=KgKuiU9g@mail.gmail.com>
 <20121009214915.GD27882@quack.suse.cz> <CAD6i1f+hqmjJAO1mAM3o2gtv4qMGJuosen28RLuAwMLMnFTYSw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:59107 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753154Ab2LDNKz (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 4 Dec 2012 08:10:55 -0500
Received: by mail-ea0-f174.google.com with SMTP id e13so1587745eaa.19
        for <linux-ext4@vger.kernel.org>; Tue, 04 Dec 2012 05:10:54 -0800 (PST)
In-Reply-To: <CAD6i1f+hqmjJAO1mAM3o2gtv4qMGJuosen28RLuAwMLMnFTYSw@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Wed, Oct 10, 2012 at 3:19 AM, Jan Kara <jack@suse.cz> wrote:
>>   OK. There are several ways how I could imagine you hit ino == 0. Either
>> someone is using direct IO or inode is a block device inode...
>>

Most of the inode 0 writes belonged to journal (verified with the
sector number). I think that such journal writes should set the inode
to 8 or whatever is reserved for the journal rather than 0.

Regards.
