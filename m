From: "Manish Katiyar" <mkatiyar@gmail.com>
Subject: Re: Copying Data Blocks
Date: Tue, 6 Jan 2009 18:54:49 +0530
Message-ID: <ea11fea30901060524n559a48f1h85bbf27be5b30b50@mail.gmail.com>
References: <2d08ef090901060236p46d4d396x797e4bceb24a2a34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ext4 <linux-ext4@vger.kernel.org>,
	Kernelnewbies <kernelnewbies@nl.linux.org>
To: "Rohit Sharma" <imreckless@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:52454 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723AbZAFN0T (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Tue, 6 Jan 2009 08:26:19 -0500
Received: by ti-out-0910.google.com with SMTP id b6so9821126tic.23
        for <linux-ext4@vger.kernel.org>; Tue, 06 Jan 2009 05:24:49 -0800 (PST)
In-Reply-To: <2d08ef090901060236p46d4d396x797e4bceb24a2a34@mail.gmail.com>
Content-Disposition: inline
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Tue, Jan 6, 2009 at 4:06 PM, Rohit Sharma <imreckless@gmail.com> wrote:
> I want to read data blocks from one inode
> and copy it to other inode.
>
> I mean to copy data from data blocks associated with one inode
> to the data blocks associated with other inode.

Copying 4K chunk of data itself is a costly operation. and depending
on the size of your donor inode this can be huge . Why do you want to
do that ? Do you know the inode of the donor inode ?

thanks -
Manish
>
> Is that possible in kernel space.?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ext4" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
