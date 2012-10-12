From: Prashant Shah <pshah.mumbai@gmail.com>
Subject: Re: freeze_bdev hangs
Date: Fri, 12 Oct 2012 21:38:15 +0530
Message-ID: <CAD6i1f+hqmjJAO1mAM3o2gtv4qMGJuosen28RLuAwMLMnFTYSw@mail.gmail.com>
References: <CAD6i1f+fzh-z+Xr6V2gHBzq4kmJzPcfre91g=q6fJ7P_5nY0Zw@mail.gmail.com>
 <506F19E6.8030005@redhat.com> <CAD6i1fJbfiBnTu1ttisMr96PzaTWCLAsvmTjx7OevfPcAGd7-A@mail.gmail.com>
 <20121008161926.GH9243@quack.suse.cz> <CAD6i1fKpWZVbL4gS1ui7GvF81S+SAduckXeWoApwH=KgKuiU9g@mail.gmail.com>
 <20121009214915.GD27882@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48016 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964891Ab2JLQIh (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Oct 2012 12:08:37 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so1952459eek.19
        for <linux-ext4@vger.kernel.org>; Fri, 12 Oct 2012 09:08:35 -0700 (PDT)
In-Reply-To: <20121009214915.GD27882@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi,

On Wed, Oct 10, 2012 at 3:19 AM, Jan Kara <jack@suse.cz> wrote:
>   OK. There are several ways how I could imagine you hit ino == 0. Either
> someone is using direct IO or inode is a block device inode...
>

Fixed one of the issues. It turn out that printk() in the request
function cause the /var/log/messages file to be updated that resulted
in more block copies in request function which in turn triggered more
printk's.

I will check the direct IO operations and report back.

Regards.
