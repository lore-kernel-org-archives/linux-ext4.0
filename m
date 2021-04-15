Return-Path: <linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBF0FC433B4
	for <linux-ext4@archiver.kernel.org>; Thu, 15 Apr 2021 05:54:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA7A761437
	for <linux-ext4@archiver.kernel.org>; Thu, 15 Apr 2021 05:54:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230335AbhDOFyf (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 15 Apr 2021 01:54:35 -0400
Received: from verein.lst.de ([213.95.11.211]:33303 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230005AbhDOFyd (ORCPT <rfc822;linux-ext4@vger.kernel.org>);
        Thu, 15 Apr 2021 01:54:33 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4690368BEB; Thu, 15 Apr 2021 07:54:08 +0200 (CEST)
Date:   Thu, 15 Apr 2021 07:54:08 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        Eryu Guan <guan@eryu.me>,
        Christian Brauner <brauner@kernel.org>,
        fstests@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-ext4@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>,
        David Howells <dhowells@redhat.com>,
        Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH -RFC] ext4: add feature file to advertise that ext4
 supports idmapped mounts
Message-ID: <20210415055408.GA8947@lst.de>
References: <20210328223400.1800301-3-brauner@kernel.org> <YHMH/JRmzg3ETcED@desktop> <20210411151249.6y34x7yatqtpcvi6@wittgenstein> <20210411151857.wd6gd46u53vlh2xv@wittgenstein> <YHMUAL/oD4fB3+R7@desktop> <20210411153223.vhcegiklrwoczy55@wittgenstein> <YHOW7DN51YuYgLPM@mit.edu> <20210412115426.a4bzsx4cp7jhx2ou@wittgenstein> <YHTMkBcVTFAGqyks@mit.edu> <YHdUzqZ7PZtb64zf@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHdUzqZ7PZtb64zf@mit.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Wed, Apr 14, 2021 at 04:47:10PM -0400, Theodore Ts'o wrote:
> On Mon, Apr 12, 2021 at 06:41:20PM -0400, Theodore Ts'o wrote:
> > In the ideal world, if the kernel wasn't compiled with the necessary
> > CONFIG options enabled, it's desirable of the test can detect that
> > fact and skip running the test instead failing and forcing the person
> > running the test to try to figure out whether this is a legitmate file
> > system bug or a just a test setup bug.
> 
> So it would make it easier for me to manage running xfstests on ext4
> if I had added something like this to ext4 and sent it to Linus before
> v5.12 is released.  What do folks think?

Completely stupid.  This is a VFS-level feature and we need to have
proper VFS-level testing (which we have through creating a mount
with the option), not fs-specific band aids.
