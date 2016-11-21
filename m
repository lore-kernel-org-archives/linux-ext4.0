From: Eric Biggers <ebiggers@google.com>
Subject: Re: [PATCH] ext4: fix reading new encrypted symlinks on no-journal
 filesystems
Date: Mon, 21 Nov 2016 15:19:24 -0800
Message-ID: <20161121231924.GG30672@google.com>
References: <1479318627-143193-1-git-send-email-ebiggers@google.com>
 <2FD4E662-B708-4C34-B1FC-8D42083322A2@dilger.ca>
 <20161118184704.GA73496@google.com>
 <75C88E0E-FF89-4D20-B11C-8F705E249BDD@dilger.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-ext4 <linux-ext4@vger.kernel.org>,
        Theodore Ts'o <tytso@mit.edu>
To: Andreas Dilger <adilger@dilger.ca>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:33975 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755091AbcKUXT2 (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Mon, 21 Nov 2016 18:19:28 -0500
Received: by mail-pf0-f180.google.com with SMTP id c4so167448pfb.1
        for <linux-ext4@vger.kernel.org>; Mon, 21 Nov 2016 15:19:28 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <75C88E0E-FF89-4D20-B11C-8F705E249BDD@dilger.ca>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Fri, Nov 18, 2016 at 02:52:22PM -0700, Andreas Dilger wrote:
> 
> > Yes, this would be a much nicer way to detect fast symlinks.
> > 
> > The only thing I'd be concerned about is the possibility of pre-existing
> > "slow" symlinks that actually have targets short enough to be "fast"
> > symlinks, perhaps in filesystems created by old drivers or by external
> > tools.  If such links happened to work before, then a change to check
> > i_size would break them.
> > 
> > This may not be an issue in practice.  I checked some old ext4 versions,
> > ext2 from Linux 0.99.7, e2fsprogs, Android's ext4_utils, and FreeBSD's
> > ext2 driver.
> > They all create "fast" symlinks if the length of the symlink target length
> > excluding the terminating null (i_size) is < 60.
> 
> I did a similar analysis with similar results.
> 

Ted, what would you say about Andreas' suggestion to use i_size to distinguish
fast symlinks from slow symlinks?

It looks like this was discussed some years ago but the discussion died out and
no change was made: see https://www.spinics.net/lists/linux-ext4/msg05693.html

Given the investigation I did it seems it would very likely be safe, but we can
never be 100% sure it won't break some obscure tool or (version of a tool) to
create symlinks on ext2/ext3/ext4 filesystems we don't know about.

Eric
