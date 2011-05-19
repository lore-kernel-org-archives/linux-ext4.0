From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [Ocfs2-devel] [PATCH] ocfs2: Implement llseek()
Date: Thu, 19 May 2011 10:29:08 -0700
Message-ID: <4DD55364.8070002@oracle.com>
References: <1305773084-19296-1-git-send-email-sunil.mushran@oracle.com> <1305773084-19296-3-git-send-email-sunil.mushran@oracle.com> <20110519110531.GB6357@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: josef@redhat.com, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org, viro@ZenIV.linux.org.uk,
	ocfs2-devel@oss.oracle.com
To: Christoph Hellwig <hch@lst.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20110519110531.GB6357@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On 05/19/2011 04:05 AM, Christoph Hellwig wrote:
> On Wed, May 18, 2011 at 07:44:44PM -0700, Sunil Mushran wrote:
>> Unwritten (preallocated) extents are considered holes because the file system
>> treats reads to such regions in the same way as it does to holes.
> How does this work for the case of an unwrittent extent that has been
> written to in the pagecache but not converted yet?  Y'know the big data
> corruption and flamewar that started all this?

We don't delay splitting the extent. It is split in ->write_begin(). Delaying
it will be a challenge as we have to provide cache coherency across the
cluster.

