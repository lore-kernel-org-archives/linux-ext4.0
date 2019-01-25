Return-Path: <SRS0=p9Mw=QB=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E632AC282C3
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 00:32:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1CEB218D2
	for <linux-ext4@archiver.kernel.org>; Fri, 25 Jan 2019 00:32:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ka1BWXch"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727649AbfAYAcY (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Thu, 24 Jan 2019 19:32:24 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38060 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbfAYAcY (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Thu, 24 Jan 2019 19:32:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4Oec1ND39UztJZ3DJehcMug6w2FZDhWxqgxFfuFqqXY=; b=Ka1BWXchDBDv5oZ4g2BglwmZX
        j/uh2m9UC92aAGMeWM6U0QwSiB+0o8Dj5IDfuvzAVkHoV5/2d3SEJiTQft7/7/7y7Xp6rxV1L3sUb
        TfokBQRCjPYMyCeP56Ov3PtuseSUgpjsCdyT88AcTFPMVD9lQtVcon8kqlrSX+zHYKlKvd3jNnTG9
        GQxAsxOLpzTKvrYYBVFpSof74MpaDG5pUi7KeFTtaNlqwO4ZBpvKKgdwDkUQG8auwCoc7D29OgKmW
        g9v1baM2Kl6xE2T+u7y0my8FZdM3WELTmPkCotrIKklHtMHWW9xoG6uIG6vgcOqqdT0UrwVd7ZNIn
        dUy+uZSiw==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1gmpPt-0002mx-VC; Fri, 25 Jan 2019 00:32:17 +0000
Date:   Thu, 24 Jan 2019 16:32:17 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: Proposal: A new fs-verity interface
Message-ID: <20190125003217.GB18522@bombadil.infradead.org>
References: <20190110051500.GA32361@mit.edu>
 <20190114234101.GQ27534@dastard>
 <20190123051017.GA8785@mit.edu>
 <20190124212544.GS6173@dastard>
 <CAHk-=wh7jq6U3+ou_FDujB-ipg9JcJAGSjEQ_niCwLG313x6UA@mail.gmail.com>
 <20190124232237.GH8785@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124232237.GH8785@mit.edu>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Thu, Jan 24, 2019 at 06:22:37PM -0500, Theodore Y. Ts'o wrote:
> The main issue is that for a 129 MB file, the Merkle data is going to
> be a Megabyte.

127MB ... I pointed out this error the last time the documentation
was posted.

> We could store the metadata somewhere else --- for example, we could
> store it in another inode.  But inodes have overhead, and that would
> mean using two inodes for every fs-verity protected files --- and we
> don't need all of the other metadata (mtime, ctime, etc.) for the
> Merkle tree.  So that's how we got to where we were.  I think the
> approach of storing it using the same extent tree where we map logical
> block numbers to physical block numbers make a lot of sense for ext4
> and f2fs.
> 
> It seems that some file system (which may never even implement
> fs-verity) their developers hate that particular approach.  So that's
> where the suggestion of using a separate file descriptor to convey the
> Merkle tree data to the file system came from.  It wasn't my first
> choice.

I'll reiterate an API I suggested on December 21st:

: verity_fd = ioctl(fd, FS_IOC_VERITY_FD);
: write(verity_fd, &merkle_tree);
: close(verity_fd);
: 
: At final close of that verity_fd, the filesystem behaves in the same way
: that it does on receipt of this FS_IOC_ENABLE_VERITY ioctl today.

