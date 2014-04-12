From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/4] fs: Remove i_size check from do_fallocate
Date: Sat, 12 Apr 2014 08:21:17 -0700
Message-ID: <20140412152117.GB18047@infradead.org>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
 <1397242665-2183-3-git-send-email-lczerner@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Lukas Czerner <lczerner@redhat.com>
Return-path: <ceph-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1397242665-2183-3-git-send-email-lczerner@redhat.com>
Sender: ceph-devel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

Looks good, but the subject line is misleading, it should read something
like:

"fs: move falloc collapse range check into the filesystem methods"

Might also be worth mentioning that size checks for the other modes
are in the filesystems in the the long description.

Reviewed-by: Christoph Hellwig <hch@lst.de>
