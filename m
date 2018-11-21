Return-Path: <SRS0=ZxZh=OA=vger.kernel.org=linux-ext4-owner@kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54184 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726001AbeKUT5Z (ORCPT
        <rfc822;linux-ext4@vger.kernel.org>); Wed, 21 Nov 2018 14:57:25 -0500
Date: Wed, 21 Nov 2018 01:23:14 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Eiichi Tsukata <devel@etsukata.com>
Cc: andi@firstfloor.org, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v1 3/4] f2fs: fix race between llseek SEEK_END and write
Message-ID: <20181121092314.GB10667@infradead.org>
References: <20181121024400.4346-1-devel@etsukata.com>
 <20181121024400.4346-4-devel@etsukata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181121024400.4346-4-devel@etsukata.com>
Sender: linux-ext4-owner@vger.kernel.org
List-ID: <linux-ext4.vger.kernel.org>

On Wed, Nov 21, 2018 at 11:43:59AM +0900, Eiichi Tsukata wrote:
> This patch itself seems to be just a cleanup but with the
> commit b25bd1d9fd87 ("vfs: fix race between llseek SEEK_END and write")
> it fixes race.

Please move this patch to the beginning of the series and replace
the commit log with something like the one below.  Note that your
commit id is different from the one that will appear once applied
upstream, so the aboe isn't too helpful.

---
f2fs: use generic_file_llseek

f2fs always passes inode->i_sb->s_maxbytes to generic_file_llseek_size,
and thus should simply use generic_file_llseek.  For now this is a just
a cleanup, but it will allow f2fs to pick up a race fix in
generic_file_llseek for free.
