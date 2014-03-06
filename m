From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
Subject: Re: [PATCH v2 6/8] fsstress: translate flags in fiemap_f
Date: Thu, 6 Mar 2014 19:02:16 +0100 (CET)
Message-ID: <alpine.LFD.2.00.1403061900300.2249@localhost.localdomain>
References: <1394034699-21187-1-git-send-email-lczerner@redhat.com>
	<1394034699-21187-7-git-send-email-lczerner@redhat.com>
	<20140306174813.GE28297@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20140306174813.GE28297@infradead.org>
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

> Date: Thu, 6 Mar 2014 09:48:13 -0800
> From: Christoph Hellwig <hch@infradead.org>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com
> Subject: Re: [PATCH v2 6/8] fsstress: translate flags in fiemap_f
> 
> > +#ifdef HAVE_LINUX_FIEMAP_H
> > +struct print_flags fiemap_flags[] = {
> > +	{ FIEMAP_FLAG_SYNC, "SYNC"},
> > +	{ FIEMAP_FLAG_XATTR, "XATTR"},
> > +	{ -1, NULL}
> > +};
> 
> Can be static.

Right. The same applies to falloc_flags

> 
> > +
> > +#define translate_fiemap_flags(mode)	\
> > +	({translate_flags(mode, "|", fiemap_flags);})
> > +#endif
> 
> Any reason to not have these two inside fiemap_f?

Not really, other than I think it's ugly.

> 
> Otherwise:
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
