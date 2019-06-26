Return-Path: <SRS0=SjVU=UZ=vger.kernel.org=linux-ext4-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA9BC48BD6
	for <linux-ext4@archiver.kernel.org>; Wed, 26 Jun 2019 04:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 515E62082F
	for <linux-ext4@archiver.kernel.org>; Wed, 26 Jun 2019 04:02:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbfFZECx (ORCPT <rfc822;linux-ext4@archiver.kernel.org>);
        Wed, 26 Jun 2019 00:02:53 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44324 "EHLO
        ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbfFZECx (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 26 Jun 2019 00:02:53 -0400
Received: from viro by ZenIV.linux.org.uk with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hfz8F-000086-0E; Wed, 26 Jun 2019 04:02:03 +0000
Date:   Wed, 26 Jun 2019 05:02:02 +0100
From:   Al Viro <viro@zeniv.linux.org.uk>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     matthew.garrett@nebula.com, yuchao0@huawei.com, tytso@mit.edu,
        shaggy@kernel.org, ard.biesheuvel@linaro.org, josef@toxicpanda.com,
        hch@infradead.org, clm@fb.com, adilger.kernel@dilger.ca,
        jk@ozlabs.org, jack@suse.com, dsterba@suse.com, jaegeuk@kernel.org,
        cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net,
        linux-efi@vger.kernel.org, Jan Kara <jack@suse.cz>,
        reiserfs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-nilfs@vger.kernel.org, linux-mtd@lists.infradead.org,
        ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/5] vfs: create a generic checking and prep function for
 FS_IOC_SETFLAGS
Message-ID: <20190626040202.GA32272@ZenIV.linux.org.uk>
References: <156151632209.2283456.3592379873620132456.stgit@magnolia>
 <156151633004.2283456.4175543089138173586.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156151633004.2283456.4175543089138173586.stgit@magnolia>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-ext4-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-ext4.vger.kernel.org>
X-Mailing-List: linux-ext4@vger.kernel.org

On Tue, Jun 25, 2019 at 07:32:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <darrick.wong@oracle.com>
> 
> Create a generic function to check incoming FS_IOC_SETFLAGS flag values
> and later prepare the inode for updates so that we can standardize the
> implementations that follow ext4's flag values.

Change in efivarfs behaviour deserves a note.  I'm not saying it's wrong,
but behaviour is changed there - no-op FS_IOC_SETFLAGS used to fail
without CAP_LINUX_IMMUTABLE...
