From: Andrew Watts <akwatts@ymail.com>
Subject: Re: [OOPS]: Kernel 3.1 (ext3?)
Date: Tue, 22 Nov 2011 06:42:49 -0500
Message-ID: <20111122114247.GB20081@zeus>
References: <20111110132929.GA11417@zeus>
 <20111114195352.GB17328@quack.suse.cz>
 <alpine.DEB.2.00.1111151004050.22502@router.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org
To: Christoph Lameter <cl@linux.com>
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111151004050.22502@router.home>
Sender: owner-linux-mm@kvack.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Nov 15, 2011 at 10:05:25AM -0600, Christoph Lameter wrote:
> On Mon, 14 Nov 2011, Jan Kara wrote:
> 
> > On Thu 10-11-11 08:29:37, Andrew Watts wrote:
> > > I had the following kernel panic today on 3.1 (machine was compiling code
> > > unattended). It would appear to be a bug/regression introduced sometime
> > > between 2.6.39.4 and 3.1.
> >   Hmm, the report is missing a line (top one) saying why the kernel
> > actually crashed. Can you add that?
> >
> >   Also it seems you are using SLUB allocator, right? This seems like a
> > problem there so adding some CCs.
> 
> Likely some data corruption. Enable slub debugging by passing
> 
> slub_debug
> 
> on the kernel commandline please to get some information as to where and
> when this happens.
> 

Hi Christoph.

Thank you for your reply. I'll enable slub debugging and post anything of
interest.

~ Andy

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
