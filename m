Return-Path: <SRS0=SNdn=7Z=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8CE4C433DF
	for <linux-ext4@archiver.kernel.org>; Fri, 12 Jun 2020 17:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88E61207F7
	for <linux-ext4@archiver.kernel.org>; Fri, 12 Jun 2020 17:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgFLRir (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Fri, 12 Jun 2020 13:38:47 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:56165 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726085AbgFLRir (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Fri, 12 Jun 2020 13:38:47 -0400
Received: from callcc.thunk.org (pool-100-0-195-244.bstnma.fios.verizon.net [100.0.195.244])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 05CHcZka021591
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Jun 2020 13:38:36 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 5F645420E61; Fri, 12 Jun 2020 13:38:35 -0400 (EDT)
Date:   Fri, 12 Jun 2020 13:38:35 -0400
From:   "Theodore Y. Ts'o" <tytso@mit.edu>
To:     Jan Nieuwenhuizen <janneke@gnu.org>
Cc:     linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Danny Milosavljevic <dannym@scratchpost.org>,
        Samuel Thibault <samuel.thibault@gnu.org>
Subject: Re: [PATCH v2] ext4: support xattr gnu.* namespace for the Hurd
Message-ID: <20200612173835.GA2863913@mit.edu>
References: <20200525193940.878-1-janneke@gnu.org>
 <20200529032505.GM228632@mit.edu>
 <87imgfuoc4.fsf@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87imgfuoc4.fsf@gnu.org>
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Fri, May 29, 2020 at 10:39:39AM +0200, Jan Nieuwenhuizen wrote:
> Theodore Y. Ts'o writes:
> 
> Hello!
> 
> > On Mon, May 25, 2020 at 09:39:40PM +0200, Jan (janneke) Nieuwenhuizen wrote:
> >> The Hurd gained[0] support for moving the translator and author
> >> fields out of the inode and into the "gnu.*" xattr namespace.
> >> 
> >> In anticipation of that, an xattr INDEX was reserved[1].  The Hurd has
> >> now been brought into compliance[2] with that.
> >> 
> >> This patch adds support for reading and writing such attributes from
> >> Linux; you can now do something like
> 
> [...]
> >
> > This patch is missing a Signed-off-by.  If you don't understand why
> > this is really important, please read: 
> >
> > https://www.kernel.org/doc/html/latest/process/submitting-patches.html#sign-your-work-the-developer-s-certificate-of-origin
> 
> Ah, that makes sense.  Sorry for omitting that/being not clear on it.
> 
> > Can you resubmit with the DCO or confirm that it's OK for me to add
> > your Signed-off-by?
> 
> Yes, that's OK, please do!  I am the original author of this patch.

Thanks, I've applied this to the ext4.git tree.

						- Ted
