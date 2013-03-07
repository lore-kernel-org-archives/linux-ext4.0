From: Andreas Dilger <adilger@dilger.ca>
Subject: Re: Mixup with name_len & file_type in e2fsprogs
Date: Fri, 8 Mar 2013 07:00:07 +0800
Message-ID: <F92ABD11-CD88-4A98-A419-D70EBB9AD55A@dilger.ca>
References: <20130305121856.GA11824@quack.suse.cz> <20130305182946.GB26122@thunk.org> <20130305184138.GA19601@quack.suse.cz> <20130307182444.GA21237@quack.suse.cz>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org
To: Jan Kara <jack@suse.cz>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:37930 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3CGXAM (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Thu, 7 Mar 2013 18:00:12 -0500
Received: by mail-pb0-f44.google.com with SMTP id wz12so709405pbc.17
        for <linux-ext4@vger.kernel.org>; Thu, 07 Mar 2013 15:00:11 -0800 (PST)
In-Reply-To: <20130307182444.GA21237@quack.suse.cz>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 2013-03-08, at 2:24 AM, Jan Kara wrote:
Won't it be cleaner (and not much
> harder) if we always used ext2_dir_entry_2 in e2fsprogs and properly
> did byte swapping of name_len only if FILETYPE feature isn't enabled?
> I've checked and it would mean changing prototypes of like 8
> functions in ext2fs.h (or better provide new functions with struct
> ext2_dir_entry_2 argument) which doesn't seem too bad... This
> solution seems to be the least surprising to the users of libext2fs
> (esp. if they do some scanning of directory blocks themselves or so).

I've wanted to do this for a while as well.  Or even go further and
just deprecate support for filesystems that don't have the FILETYPE
feature (which has been supported since Linux 1.2 or even earlier).

Cheers, Andreas
