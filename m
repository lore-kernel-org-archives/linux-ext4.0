From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH 4/4] fs: Disallow all fallocate operation on active
	swapfile
Date: Tue, 15 Apr 2014 15:19:47 +0200 (CEST)
Message-ID: <alpine.LFD.2.00.1404151510560.2146@localhost.localdomain>
References: <1397242665-2183-1-git-send-email-lczerner@redhat.com>
	<1397242665-2183-4-git-send-email-lczerner@redhat.com>
	<20140412152225.GC18047@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
	linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20140412152225.GC18047@infradead.org>
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

> Date: Sat, 12 Apr 2014 08:22:25 -0700
> From: Christoph Hellwig <hch@infradead.org>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
>     linux-ext4@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH 4/4] fs: Disallow all fallocate operation on active
>     swapfile
> 
> Given that the earlier patches were about races - what protects us
> from swapon racing with the check outside the filesystem locks?
> 

That would be fairies :) This patch is obviously wrong so I'll drop
it and try to think about better way of dealing with this.

Thanks!
-Lukas

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
