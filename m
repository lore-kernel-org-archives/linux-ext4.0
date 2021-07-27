Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67351C4338F
	for <linux-ext4@archiver.kernel.org>; Tue, 27 Jul 2021 22:06:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4DE1E60F59
	for <linux-ext4@archiver.kernel.org>; Tue, 27 Jul 2021 22:06:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhG0WGx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Tue, 27 Jul 2021 18:06:53 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:50537 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231599AbhG0WGw (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Tue, 27 Jul 2021 18:06:52 -0400
Received: from cwcc.thunk.org (pool-72-74-133-215.bstnma.fios.verizon.net [72.74.133.215])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 16RM6VD2022989
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 27 Jul 2021 18:06:31 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id D848915C3DBC; Tue, 27 Jul 2021 18:06:30 -0400 (EDT)
Date:   Tue, 27 Jul 2021 18:06:30 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Andreas Dilger <adilger@dilger.ca>
Cc:     Mike Fleetwood <mike.fleetwood@googlemail.com>,
        Reindl Harald <h.reindl@thelounge.net>,
        linux-ext4@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: Is labelling a mounted ext2/3/4 file system safe and supported?
Message-ID: <YQCDZgZMf1Qfsvah@mit.edu>
References: <CAMU1PDgJAadK21H_-u3vg0NujKRzBegH0SHL2+54+23ZppFDgQ@mail.gmail.com>
 <8A4E4147-0D89-4B2B-A118-F5EDABF9ABD5@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8A4E4147-0D89-4B2B-A118-F5EDABF9ABD5@dilger.ca>
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jul 27, 2021 at 01:49:39AM -0600, Andreas Dilger wrote:
> > Looking at the e2label source code, it just reads the superblock,
> > updates the label and writes the super block.  How is that safe and
> > persistent when presumably the linux kernel has an in-memory copy of the
> > superblock will be written at unmount and presumable sync.
> 
> Currently, the in-memory superblock references the device buffer cache,
> which is the same cache that is accessed when reading the block
> device from userspace, so they are always consistent.
> 
> There has been some discussion about adding ioctl() calls to update
> the filesystem label, UUID, and other fields from userspace in a safer way,
> but nothing has been implemented in that direction yet (possibly Darrick
> had some RFC patches, but they are not landed yet).

As Andreas has stated, e2fsprogs programs such as e2label and tune2fs
use buffered I/O to read and write the superblock, which accesses the
buffer cache, which is where the kernel's copy superblock used by the
file system code is located.  It's not perfect; for example an updated
label written by e2label might get lost when it is overwritten by a
journal replay after a system crash.  But for the most part, it does
work.

Cheers,

						- Ted
