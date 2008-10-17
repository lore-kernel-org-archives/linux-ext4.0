From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: undelete still opened file
Date: Fri, 17 Oct 2008 14:33:11 +0200
Message-ID: <20081017143311.52d50a23.taeuber@bbaw.de>
References: <20081017120852.1f04dc36.taeuber@bbaw.de>
	<ea11fea30810170333n4ba9a681l7b64862834899aac@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: "Manish Katiyar" <mkatiyar@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail.bbaw.de ([194.95.188.6]:47385 "EHLO mail.bbaw.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867AbYJQMcA (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Fri, 17 Oct 2008 08:32:00 -0400
In-Reply-To: <ea11fea30810170333n4ba9a681l7b64862834899aac@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

Hi Manish,


"Manish Katiyar" <mkatiyar@gmail.com> schrieb:
> > I thought about something in connection with /proc/####/fd/# .
> > Is there any chance to get the file back to normal?
> 
> To some extent yes......

yes I know I could do this:

cat /proc/####/fd/32 > /dir/to/new/file.ext

but then all changes made by the process afterwards are not in the copy.

> You can try the /proc/****/fd/** approach . It has worked for me in
> past......but that was for a running binary.

Of course there is a process still running and works with a file discriptor to the deleted file.

Onother question:
Is the space of the file on the underlying block device already marked as free? Or does this happen after all processes have closed all file descriptors pointing to the file?

I really want to undo the deletion. (get a link/name connected to the root inode of the file again)
Is there a way to do this?

Thanks
Lars
