From: Aditya Kali <adityakali@google.com>
Subject: Re: how to quotacheck with the new quota implementation (hidden inode)?
Date: Mon, 21 Jan 2013 11:34:27 -0800
Message-ID: <CAGr1F2HXEGiOA4jVQ-n9cAgOkWxdUd5tphTq4m9aRujBge-Qqg@mail.gmail.com>
References: <20730.1955.395545.141779@fisica.ufpr.br> <20130121054741.GB321@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Carlos Carvalho <carlos@fisica.ufpr.br>,
	ext4 development <linux-ext4@vger.kernel.org>,
	Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:63338 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab3AUTer (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Jan 2013 14:34:47 -0500
Received: by mail-ie0-f182.google.com with SMTP id s9so10463609iec.13
        for <linux-ext4@vger.kernel.org>; Mon, 21 Jan 2013 11:34:47 -0800 (PST)
In-Reply-To: <20130121054741.GB321@thunk.org>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Sun, Jan 20, 2013 at 9:47 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sat, Jan 19, 2013 at 12:40:35AM -0200, Carlos Carvalho wrote:
>> I've started to use the new quota implementation (3.7.3 running now).
>> I used tune2fs -Q to turn non {usr,grp}quota. It's nice, no need to
>> run quotaon and all the jquota=file options. It works but it starts
>> counting only what comes after the mount with the new quota. If there
>> is already stuff in the filesystem it's not counted. How can we do a
>> quotacheck?
>
> tune2fs -Q should have set up the quota inodes with the correct usage
> information.  What version of e2fsprogs were you using?  If the quota
> information is incorrect, e2fsck will correct it --- so e2fsck will
> serve as the quota check.
>
> That being said, I've been doing some testing, and I have found some
> shortcomings with the e2fsck's handling of the quota option that we
> need to fix before I can recommend people use the new quota
> implementation.
>
> 1) The e2fsck check of the on-disk quota inodes won't notice if there
> is a missing uid record.  (i.e., if some uid, say daemon owns a bunch
> of files, but that uid record is not in the quota inode, e2fsck won't
> say boo.)
>
> 2) If e2fsck *does* notice a discrepancy between the usage information
> recorded in the hidden quota inodes, and the actual number of blocks
> used by a particular user id or group id, it will overwrite the user
> or group quota inode with all of the information it has.
> Unfortunately, in the process it will zero out all of the current
> quota limits set.   This is unfortunate....
>
I thought I had made the change to e2fsck to maintain limits as well,
but looking at code now it does seem that e2fsck will discard the
limits during fixing. tune2fs does maintain limits if the previous
quota files (in V1 format) are present. I can send a patch to fix
e2fsck. (1) above will be a bit tricky to fix though. I will take a
look at it too.

Thanks,
--
Aditya
