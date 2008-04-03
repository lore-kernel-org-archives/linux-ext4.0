From: Joel Becker <Joel.Becker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ANNOUNCEMENT] Linux POSIX file system test suite
Date: Thu, 3 Apr 2008 09:48:54 -0700
Message-ID: <20080403164854.GA5730@ca-server1.us.oracle.com>
References: <Pine.LNX.4.62.0804022313390.664@tamago.serverit.net>
	<20080402222344.GC23382@mail.oracle.com>
	<Pine.LNX.4.62.0804030705050.12223@tamago.serverit.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, zfs-fuse-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org,
	ntfs-3g-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	Marc Andre Tanner <mat-nIlIzYUjIIQJtRsIeMje0g@public.gmane.org>,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Szabolcs Szakacsits <szaka-IyvsvuGDJ8VBDgjK7y7TUQ@public.gmane.org>
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.62.0804030705050.12223-03lVS0d9f+JcfUEgzQKStNHuzzzSOjJt@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Sender: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Apr 03, 2008 at 07:12:12AM +0300, Szabolcs Szakacsits wrote:
> > > 	http://ntfs3g.org/sw/qa/pjd-fstest-20080402.tgz
> > 
> > 	Very interesting.  ocfs2, running as 'ext3' mode, gets:
> >
> > Failed 9/184 test scripts, 95.11% okay. 32/1950 subtests failed, 98.36% okay.
> 
> That's not bad as a start and it doesn't necessarily mean that there is 
> anything wrong with ocfs2. There are many cases when SuS says that the 
> behavior can be implementation specific.

	Yeah, I haven't looked into the failures.  Some day when I have
free time :-)

Joel

-- 

"When I am working on a problem I never think about beauty. I
 only think about how to solve the problem. But when I have finished, if
 the solution is not beautiful, I know it is wrong."
         - Buckminster Fuller

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Phone: (650) 506-8127

-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
