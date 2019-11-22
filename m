Return-Path: <SRS0=r249=ZO=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F3E0C432C0
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Nov 2019 03:57:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E0B962068D
	for <linux-ext4@archiver.kernel.org>; Fri, 22 Nov 2019 03:57:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfKVD5F (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 21 Nov 2019 22:57:05 -0500
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:60573 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726500AbfKVD5F (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 21 Nov 2019 22:57:05 -0500
Received: from callcc.thunk.org (guestnat-104-133-8-103.corp.google.com [104.133.8.103] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id xAM3utrV005734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Nov 2019 22:56:56 -0500
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 0C1334202FD; Thu, 21 Nov 2019 22:56:55 -0500 (EST)
Date:   Thu, 21 Nov 2019 22:56:54 -0500
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Ext4 Developers List <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 2/2] ext4: simulate various I/O and checksum errors when
 reading metadata
Message-ID: <20191122035654.GL4262@mit.edu>
References: <20191121183036.29385-1-tytso@mit.edu>
 <20191121183036.29385-2-tytso@mit.edu>
 <20191122000933.GG6213@magnolia>
 <20191122010026.GK4262@mit.edu>
 <20191122011834.GH6213@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122011834.GH6213@magnolia>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Nov 21, 2019 at 05:18:34PM -0800, Darrick J. Wong wrote:
> > So in theory, we could do that with dm_flakey --- but that's a pain in
> > the tuckus, since you have to specify the LBA for the directory blocks
> > that you might want to have fail.
> 
> Funny, I've been working on a fstests helper function to make it easy to
> set up dm-flakey based on fiemap/getfsmap output and such. :)

Ah, excellent, I'm looking forward to seeing it.  :-)

> > What might be interesting to do is some kind of eBPF hook where we
> > pass in the block #, inode #, and metadata type, and the ePBF program
> > could do use a much more complex set of criteria in terms of whether
> > or not to trigger an EIO, or how to fuzz a particular block to either
> > force a CRC failure, or to try to find bugs ala Hydra[1] (funded via a
> > Google Faculty Research Award grant), but using a much more glass-box
> > style test approach.
> 
> That would be fun.  Attach an arbitrary eBPF program to a range of
> sectors.  I wonder how loud the howls of protest would be for "can we
> let ebpf programs scribble on a kernel io buffer pleeze?"...

Well, because the eBPF hook would include the metadata type (an
allocation bitmap vs inode table vs htree index vs htree leaf block,
etc.) what I was thinking about has to be done in ext4 as a
ext4-specific hook.  And it would only be enabled if CONFIG_EXT4_DEBUG
or a separate Kconfig option is enabled --- and I *hope* no
distribution would be so silly/stupid enough to enable it on a product
kernel build.  :-)

						- Ted
