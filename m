Return-Path: <SRS0=DZYj=RU=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 530D3C43381
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Mar 2019 21:53:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 251FE20872
	for <linux-ext4@archiver.kernel.org>; Sun, 17 Mar 2019 21:53:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbfCQVxY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Sun, 17 Mar 2019 17:53:24 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:35919 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726333AbfCQVxY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Sun, 17 Mar 2019 17:53:24 -0400
Received: from callcc.thunk.org ([66.31.38.53])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x2HLrGWB031871
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 17 Mar 2019 17:53:16 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id CE279420AA8; Sun, 17 Mar 2019 17:53:15 -0400 (EDT)
Date:   Sun, 17 Mar 2019 17:53:15 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Ede Wolf <listac@nebelschwaden.de>
Cc:     linux-ext4@vger.kernel.org
Subject: Re: e2fsck fails on non journalled partition
Message-ID: <20190317215315.GD23356@mit.edu>
References: <bfa8103e-cf07-ca8d-f1f2-df60ea5bd915@nebelschwaden.de>
 <22AA9175-3D96-424E-BC91-6232100B170D@dilger.ca>
 <c2be64f5-d0fc-f66b-36ab-ab601301cbed@nebelschwaden.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2be64f5-d0fc-f66b-36ab-ab601301cbed@nebelschwaden.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

I'm really curious how the superblock got into this configuration:

> > > ~ # tune2fs -l /dev/sde1
> > > tune2fs 1.44.5 (15-Dec-2018)
> > > Filesystem volume name:   USERDATA
  ...
> > > Filesystem features:      ext_attr resize_inode dir_index filetype extent 64bit large_dir sparse_super large_file

There is no journal features here at all

> > > Journal UUID:             00000000-1b00-0000-0000-000000000000
> > > Journal inode:            131072

A journal UUID and inode should never be set at the same time.  But
this is a lot more than a single bit flip.  The rest of the sueprblock
looks sane, so it's not a matter of someone writing garbage over the
on-disk copy.

Maybe a wild pointer smashing two bytes in the middle of the
superblock?

In any case, this is something where we should probably add sanity
checks so kernel will refuse to mount a file system like this --- and
e2fsck should also try to see if the backup superblock is sane and try
using it.  (We could also teach e2fsck to offer to clear these fields so
a user won't have to use debugfs's ssv command if falling back to
backup superblock doesn't work.)

I'm still really wondering how this could have happened, though...

    	  	 	       	    	  - Ted
					  
