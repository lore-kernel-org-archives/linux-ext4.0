From: Eric Sandeen <sandeen@redhat.com>
Subject: Re: Block allocation in EXT4
Date: Mon, 26 Aug 2013 12:54:31 -0500
Message-ID: <521B9657.1050308@redhat.com>
References: <CAEUQceiEUQOHf8ujjbJF2Q3HSvcqo7r=KOfgoCkFGB_tE6EdcA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org
To: Subranshu Patel <spatel.ml@gmail.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30997 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab3HZRye (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
	Mon, 26 Aug 2013 13:54:34 -0400
In-Reply-To: <CAEUQceiEUQOHf8ujjbJF2Q3HSvcqo7r=KOfgoCkFGB_tE6EdcA@mail.gmail.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On 8/26/13 10:55 AM, Subranshu Patel wrote:
>  In EXT4 it seems that both direct/indirect and extent tree based
> block allocation is used. I used debugfs and it seems that the root
> inode uses the direct/indirect block allocation. The other files and
> direcyories used extent based allocation.
> 
> Do all the EXT4 reserved inode (0 -11) use the direct/indirect
> allocation scheme?

Nope; looks like a leftover oddity from old mkfs.

mkfs-time created dirs weren't created w/ the extents flag until:

commit 1afb468b9a80031b39eab37272709f45727fb221
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Jun 10 13:58:18 2011 -0400

    libext2fs: create extent-based directories if the extents feature is enabled
    
    This allows mke2fs to create the root and lost+found directories using
    extents.
    
    Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>

so newly mkfs'd filesystems w/ newer e2fsprogs shouldn't exhibit
what you see.

-Eric

