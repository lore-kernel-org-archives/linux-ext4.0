From: Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: Re: How to use new "native 4k sector sized" HDD with ext4
Date: Wed, 31 Oct 2012 11:02:27 +0530
Message-ID: <CAOiN93=zb7nujbZqBWPDO6x4p2ghmsswX-fMd79sZKFc1Bga1g@mail.gmail.com>
References: <CAOiN93kV079jkdzY-R7jMVGQq4nN4c-sdswCq-XRaOpZm=ttwA@mail.gmail.com>
	<20121030142245.GB5972@thunk.org>
	<20121031004304.GJ29378@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: "Theodore Ts'o" <tytso@mit.edu>, adilger@dilger.ca,
	sandeen@redhat.com, Namjae Jeon <linkinjeon@gmail.com>,
	linux-ext4@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Return-path: <linux-ext4-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:64460 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab2JaFc2 (ORCPT
	<rfc822;linux-ext4@vger.kernel.org>); Wed, 31 Oct 2012 01:32:28 -0400
Received: by mail-vc0-f174.google.com with SMTP id fk26so1138102vcb.19
        for <linux-ext4@vger.kernel.org>; Tue, 30 Oct 2012 22:32:27 -0700 (PDT)
In-Reply-To: <20121031004304.GJ29378@dastard>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

> That's not really correct.  XFS also uses the uses filesystem blocks
> just like ext2/3/4 for almost everything, data and metadata.
>
> However, the XFS journal format has requirements for detecting torn
> writes in journal recovery and hence needs to know the sector size
> of the log device (i.e. the minimum guaranteed atomic IO size). The
> key metadata in each AG (the AG headers) are also sector sized so
> that they don't get corrupted by torn writes, either, so XFS also
> needs to know the sector size of the data device if is using.

This perfectly explains why it makes sense for xfs.mkfs to have sectorsize
option and why this is not required for ext4.
And next time I will keep in mind to include xfs list too in cc while
asking such a question.

Thanks,

Ashish
