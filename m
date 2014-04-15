From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 3/4] fs: Remove i_size check from do_fallocate
Date: Tue, 15 Apr 2014 15:10:38 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404151510150.2146@localhost.localdomain>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
	<1397242665-2183-3-git-send-email-lczerner@redhat.com>
	<20140412152117.GB18047@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20140412152117.GB18047@infradead.org>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

On Sat, 12 Apr 2014, Christoph Hellwig wrote:

> Date: Sat, 12 Apr 2014 08:21:17 -0700
> From: Christoph Hellwig <hch@infradead.org>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
>     linux-ext4@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH 3/4] fs: Remove i_size check from do_fallocate
> 
> Looks good, but the subject line is misleading, it should read something
> like:
> 
> "fs: move falloc collapse range check into the filesystem methods"
> 
> Might also be worth mentioning that size checks for the other modes
> are in the filesystems in the the long description.

I'll update the description and the subject.

Thanks!
-Lukas

> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
