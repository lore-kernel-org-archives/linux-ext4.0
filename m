Return-Path: <SRS0=kdTK=DA=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAFD6C2D0A8
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Sep 2020 12:47:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A44820C09
	for <linux-ext4@archiver.kernel.org>; Wed, 23 Sep 2020 12:47:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UlnV1UsW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgIWMrI (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 23 Sep 2020 08:47:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51543 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726558AbgIWMrI (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 23 Sep 2020 08:47:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600865226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eTJH5fsunyc+8vtxo0cxTOWltBYbQ+uQLkgwLM6exPI=;
        b=UlnV1UsWDIPgDgPFqxX0G6a3IPA+csLnesS5W9TUaMUsXciAGJWF+VE+6ALwbhB10caIhb
        2jlzObq/vO990z0h2KkxqDUVmDL9MesNlilCVPov6QOcqKRABI2t2hpkPAMED/HCXkFt5H
        qo0K4H6R+BStbdBiNj5rVSzy/7FQ1kc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-434-RTPIZN_4P6qOg6GgeD4nRQ-1; Wed, 23 Sep 2020 08:47:02 -0400
X-MC-Unique: RTPIZN_4P6qOg6GgeD4nRQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 055D9107464E;
        Wed, 23 Sep 2020 12:47:00 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B9B05D98D;
        Wed, 23 Sep 2020 12:46:59 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 08NCkwt8020916;
        Wed, 23 Sep 2020 08:46:58 -0400
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 08NCkvuo020912;
        Wed, 23 Sep 2020 08:46:57 -0400
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Wed, 23 Sep 2020 08:46:57 -0400 (EDT)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     Jan Kara <jack@suse.cz>
cc:     "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Ira Weiny <ira.weiny@intel.com>,
        Matthew Wilcox <willy@infradead.org>,
        Eric Sandeen <esandeen@redhat.com>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: A bug in ext4 with big directories (was: NVFS XFS metadata)
In-Reply-To: <20200923094457.GB6719@quack2.suse.cz>
Message-ID: <alpine.LRH.2.02.2009230846210.1800@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.2009160649560.20720@file01.intranet.prod.int.rdu2.redhat.com> <CAPcyv4gW6AvR+RaShHdQzOaEPv9nrq5myXDmywuoCTYDZxk-hw@mail.gmail.com> <alpine.LRH.2.02.2009161254400.745@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4gD0ZFkfajKTDnJhEEjf+5Av-GH+cHRFoyhzGe8bNEgAA@mail.gmail.com> <alpine.LRH.2.02.2009161359540.20710@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.2009191336380.3478@file01.intranet.prod.int.rdu2.redhat.com> <20200922050314.GB12096@dread.disaster.area>
 <alpine.LRH.2.02.2009220815420.16480@file01.intranet.prod.int.rdu2.redhat.com> <20200923024528.GD12096@dread.disaster.area> <alpine.LRH.2.02.2009230459450.1800@file01.intranet.prod.int.rdu2.redhat.com> <20200923094457.GB6719@quack2.suse.cz>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org



On Wed, 23 Sep 2020, Jan Kara wrote:

> Hi!
> 
> On Wed 23-09-20 05:20:55, Mikulas Patocka wrote:
> > There seems to be a bug in ext4 - when I create very large directory, ext4 
> > fails with -ENOSPC despite the fact that there is plenty of free space and 
> > free inodes on the filesystem.
> > 
> > How to reproduce:
> > download the program dir-test: 
> > http://people.redhat.com/~mpatocka/benchmarks/dir-test.c
> > 
> > # modprobe brd rd_size=67108864
> > # mkfs.ext4 /dev/ram0
> > # mount -t ext4 /dev/ram0 /mnt/test
> > # dir-test /mnt/test/ 8000000 8000000
> > deleting: 7999000
> > 2540000
> > file 2515327 can't be created: No space left on device
> > # df /mnt/test
> > /dev/ram0        65531436 633752 61525860   2% /mnt/test
> > # df -i /mnt/test
> > /dev/ram0        4194304 1881547 2312757   45% /mnt/test
> 
> Yeah, you likely run out of space in ext4 directory h-tree. You can enable
> higher depth h-trees with large_dir feature (mkfs.ext4 -O large_dir). Does
> that help?

Yes, this helps.

Mikulas

> 
> 								Honza
> 
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR

