Return-Path: <SRS0=GMxu=SN=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7760EC10F13
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 21:23:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CAD22077C
	for <linux-ext4@archiver.kernel.org>; Thu, 11 Apr 2019 21:23:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726865AbfDKVXr (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 11 Apr 2019 17:23:47 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56657 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726773AbfDKVXq (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 11 Apr 2019 17:23:46 -0400
Received: from callcc.thunk.org (guestnat-104-133-9-102.corp.google.com [104.133.9.102] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x3BLNeIO012343
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Apr 2019 17:23:42 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 4DD4242048A; Thu, 11 Apr 2019 17:23:40 -0400 (EDT)
Date:   Thu, 11 Apr 2019 17:23:40 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Andrea Lo Pumo <alopumo@movia.biz>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: Run mkfs.ext4 on an already existing ext4 filesystem. Seeking
 professional help or programming hints for the recovery.
Message-ID: <20190411212340.GB28307@mit.edu>
References: <CABxFBzGv9vJsw_f9FJmJvQ2GZaz1NnVkK9a6y6CT58bv3mZj2A@mail.gmail.com>
 <CABxFBzE-kOtf3hO26RH1S7CmM+AeB6qso8OQBDOysH1L9rmjnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABxFBzE-kOtf3hO26RH1S7CmM+AeB6qso8OQBDOysH1L9rmjnQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Apr 11, 2019 at 11:37:55AM +0200, Andrea Lo Pumo wrote:
> - The inode map has been overwritten too.
> - However, the data is still there in the disk, and also the related
> inode structures. (Just the inode map is missing right?). So, if one
> is able to locate these inode structures, the relative files could be
> recovered. We know the name of important directories and files to be
> recovered. Could this help?

Unfortunately, what gets overwritten is the inode table, which
contains the inode structures.  So all of the information which says,
"logical block N of inode M is located on physical block P" is gone.

So your only hope is going to be to use a program which looks at
individual data blocks, and assumes that (for the most part) files
tend to be allocated contiguously on the storage device.  Fortunately,
such a tool has already been written, and it is an open source tool
called PhotoRec[1].  I see however, you've already tried PhotoRec.

> I could also invest some programming efforts to solve this issue, by
> hacking some available tools, if this could help and is not too
> complex. In this regard, I have this question: given that I know the
> name of some important directories and files to be recovered,
> theoretically I could write a program that "greps" the name of the
> file in /dev/sda1 and, around that point, I should locate the inode
> structure, and with the inode recover the whole file? Any hint toward
> this direction? I don't have experience with ext programming, but I am
> willing to hack.

Yeah, unfortunately, no.  You'll be able to find the directory data
block, sure.  And that will contain the inode number.  But mke2fs
overwrites the entire inode table, so there's nothing that you can
find.

> Final question: are there tools to handle this situation? testdisk and
> ext4magic do not seem to give good results. Photorec is useless to
> recover large .tar.gz and .ogg files, and more importantly the name of
> the file, which we also need.

You've listed the primary tools that are available already.  It is
possible to configure mke2fs to create an undo file, and then when
something screws up they can use the e2undo file to unwind the
modifications made by mke2fs (or e2fsck, if the undo file generation
is enabled by e2fsck).

This feature is not enabled by default, mainly because (a) it slows
down the mke2fs and e2fsck operations, and that tends to make system
administrators cranky, and (b) you have to put the e2undo file
somewhere, and you need to have some kind of scheme to delete old
e2undo files.  So there is a lot of distribution integration changes
that has never been done.

Telling you this now isn't particularly helpful, since it's basically
suggesting that you close the barn door after the horse has escaped.
However, along with other changes you might want to make to your
procedures (such as doing regular backups) to avoid future mistakes of
this ilk, it might be something to consider.

Good luck, and sorry there's not much else help we can offer you,

					- Ted
