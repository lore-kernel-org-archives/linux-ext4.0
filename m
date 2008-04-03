From: "Amar S. Tumballi" <amar-iP+wyIN8Xge1Z/+hSey0Gg@public.gmane.org>
Subject: Re: [ANNOUNCEMENT] Linux POSIX file system test suite
Date: Thu, 3 Apr 2008 09:51:37 -0700
Message-ID: <9e85838d0804030951v237fd795v12c907d583e4b44f@mail.gmail.com>
References: <Pine.LNX.4.62.0804022313390.664@tamago.serverit.net>
	<20080402222344.GC23382@mail.oracle.com>
	<Pine.LNX.4.62.0804030705050.12223@tamago.serverit.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	Joel Becker <Joel.Becker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, zfs-fuse-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org,
	ntfs-3g-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	Marc Andre Tanner <mat-nIlIzYUjIIQJtRsIeMje0g@public.gmane.org>,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Szabolcs Szakacsits" <szaka-IyvsvuGDJ8VBDgjK7y7TUQ@public.gmane.org>
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <Pine.LNX.4.62.0804030705050.12223-03lVS0d9f+JcfUEgzQKStNHuzzzSOjJt@public.gmane.org>
Content-Disposition: inline
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

Hi,
 Thanks for the test tool. It really helps us to very our posix compliance
level.

GlusterFS running as 'ext3' gets:

Failed Test                       Stat Wstat Total Fail  Failed  List of
Failed
-------------------------------------------------
/tmp/pjd-fstest-20080402/tests/ch              171    5   2.92%  69 141 145
149
                                                                 153
Failed 1/184 test scripts, 99.46% okay. 5/1950 subtests failed, 99.74% okay.

Regards,
Amar
-----


> >
> >       Very interesting.  ocfs2, running as 'ext3' mode, gets:
> >
> > Failed 9/184 test scripts, 95.11% okay. 32/1950 subtests failed, 98.36%
> okay.
>
> That's not bad as a start and it doesn't necessarily mean that there is
> anything wrong with ocfs2. There are many cases when SuS says that the
> behavior can be implementation specific.
>
> But we did find that following ext3 as close as possible will reduce the
> number of bug reports. We started from "574/1950 subtests failed, 70.56%
> okay."
>
> Regards,
>             Szaka
>
> --
> NTFS-3G:  http://ntfs-3g.org
>
> -------------------------------------------------------------------------
> Check out the new SourceForge.net Marketplace.
> It's the best place to buy or sell services for
> just about anything Open Source.
>
> http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
> _______________________________________________
> fuse-devel mailing list
> fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
> https://lists.sourceforge.net/lists/listinfo/fuse-devel
>
>


-- 
Amar Tumballi
Gluster/GlusterFS Hacker
[bulde on #gluster/irc.gnu.org]
http://www.zresearch.com - Commoditizing Supercomputing and Superstorage!
-------------------------------------------------------------------------
Check out the new SourceForge.net Marketplace.
It's the best place to buy or sell services for
just about anything Open Source.
http://ad.doubleclick.net/clk;164216239;13503038;w?http://sf.net/marketplace
