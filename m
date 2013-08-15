From: Andi Kleen <ak@linux.intel.com>
Subject: Re: page fault scalability (ext3, ext4, xfs)
Date: Wed, 14 Aug 2013 19:24:01 -0700
Message-ID: <20130815022401.GQ23412@tassilo.jf.intel.com>
References: <520BB9EF.5020308@linux.intel.com> <20130815002436.GI6023@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jan Kara <jack@suse.cz>, Dave Hansen <dave.hansen@linux.intel.com>,
	LKML <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com,
	Andy Lutomirski <luto@amacapital.net>,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	Tim Chen <tim.c.chen@linux.intel.com>
To: Dave Chinner <david@fromorbit.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20130815002436.GI6023@dastard>
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

> And FWIW, it's no secret that XFS has more per-operation overhead
> than ext4 through the write path when it comes to allocation, so
> it's no surprise that on a workload that is highly dependent on
> allocation overhead that ext4 is a bit faster....

This cannot explain a worse scaling curve though?

w-i-s is all about scaling.

-Andi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
