From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v2 1/8] xfstests: Create single function for testing
	xfs_io commands
Date: Thu, 6 Mar 2014 18:57:17 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403061856070.2249@localhost.localdomain>
References: <1394034699-21187-1-git-send-email-lczerner@redhat.com>
	<1394034699-21187-2-git-send-email-lczerner@redhat.com>
	<20140306174420.GA28297@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20140306174420.GA28297@infradead.org>
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

On Thu, 6 Mar 2014, Christoph Hellwig wrote:

> Date: Thu, 6 Mar 2014 09:44:20 -0800
> From: Christoph Hellwig <hch@infradead.org>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH v2 1/8] xfstests: Create single function for testing
>     xfs_io commands
> 
> On Wed, Mar 05, 2014 at 04:51:32PM +0100, Lukas Czerner wrote:
> > Currently there are several function testing various xfs_io commands.
> > This commit creates _require_xfs_io_command() to test any xfs_command.
> 
> Looks good.  Do you plan to keep the wrappers around
> _require_xfs_io_command in the long run or just for a transitional
> period?

I didn't really want to go back and change all the callers, but it
can be done eventually. I do not have any strong opinions either
way.

> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!
-Lukas

> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
