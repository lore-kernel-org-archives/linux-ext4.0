From: Szabolcs Szakacsits <szaka-IyvsvuGDJ8VAfugRpC6u6w@public.gmane.org>
Subject: Re: [ANNOUNCEMENT] Linux POSIX file system test suite
Date: Mon, 7 Apr 2008 02:34:16 +0300 (EEST)
Message-ID: <Pine.LNX.4.62.0804070207160.25240@tamago.serverit.net>
References: <Pine.LNX.4.62.0804022313390.664@tamago.serverit.net>
	<1207247251.30407.59.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: shaggy-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	zfs-fuse-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org,
	linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	ntfs-3g-devel-TtF/mJH4Jtrk1uMJSBkQmQ@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	chris.mason-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
To: Badari Pulavarty <pbadari-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <1207247251.30407.59.camel-Tq0y/nC7FQqofirLTBlK79w6IDGaBKkJqyM6JfAXOaQ@public.gmane.org>
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


On Thu, 3 Apr 2008, Badari Pulavarty wrote:
> On Thu, 2008-04-03 at 00:29 +0300, Szabolcs Szakacsits wrote:
>
> > The default file system type is ext3 and it passes all tests.
> 
> Hmm.. I ran it against ext2, ext3, jfs, btrfs. I don't see all "pass"
> on ext3. What am I missing ?

Your unique, consistently failing test cases for all file systems suggest 
that you have a buggy private kernel or some other individual issue in your 
test environment.

You could use the -x debug shell option in the test scripts, rerun the 
failing ones and they will show why these test cases exactly fail.
 
> btrfs seems to have little more failures.

If you find the reason for the unexpected failures then the btrfs result 
will be quite good. Apparently it has only a few link, truncate, and unlink 
ctimes update problems. I think that's quite impressive in its state of 
development.

	Szaka


> ext2:
> ====
> 
> Failed Test                     Stat Wstat Total Fail  Failed  List of Failed
> -------------------------------------------------------------------------------
> /root/posix/tests/chmod/00.t                  58    2   3.45%  3 19
> /root/posix/tests/chown/00.t                 171    4   2.34%  141 145 149 153
> /root/posix/tests/link/00.t                   82    6   7.32%  3 5-6 8-10
> /root/posix/tests/open/05.t                   12    2  16.67%  5 9
> /root/posix/tests/rename/00.t                 79    9  11.39%  3 6 8-9 11 13 37
>                                                                39 42
> /root/posix/tests/symlink/00.t                14    2  14.29%  2 5
> /root/posix/tests/truncate/05.t               15    5  33.33%  5-6 10-12
> /root/posix/tests/truncate/12.t                3    1  33.33%  2
> /root/posix/tests/truncate/13.t                4    2  50.00%  2-3
> Failed 9/184 test scripts, 95.11% okay. 33/1950 subtests failed, 98.31% okay.
> 
> 
> ext3:
> ====
> 
> Failed Test                     Stat Wstat Total Fail  Failed  List of Failed
> -------------------------------------------------------------------------------
> /root/posix/tests/chmod/00.t                  58    2   3.45%  3 19
> /root/posix/tests/link/00.t                   82    6   7.32%  3 5-6 8-10
> /root/posix/tests/open/05.t                   12    2  16.67%  5 9
> /root/posix/tests/rename/00.t                 79    9  11.39%  3 6 8-9 11 13 37
>                                                                39 42
> /root/posix/tests/symlink/00.t                14    2  14.29%  2 5
> /root/posix/tests/truncate/05.t               15    5  33.33%  5-6 10-12
> /root/posix/tests/truncate/12.t                3    1  33.33%  2
> /root/posix/tests/truncate/13.t                4    2  50.00%  2-3
> Failed 8/184 test scripts, 95.65% okay. 29/1950 subtests failed, 98.51% okay.
> 
> 
> jfs:
> ===
> 
> Failed Test                     Stat Wstat Total Fail  Failed  List of Failed
> -------------------------------------------------------------------------------
> /root/posix/tests/chmod/00.t                  58    2   3.45%  3 19
> /root/posix/tests/chown/00.t                 171    4   2.34%  141 145 149 153
> /root/posix/tests/link/00.t                   82    6   7.32%  3 5-6 8-10
> /root/posix/tests/open/05.t                   12    2  16.67%  5 9
> /root/posix/tests/rename/00.t                 79    9  11.39%  3 6 8-9 11 13 37
>                                                                39 42
> /root/posix/tests/symlink/00.t                14    2  14.29%  2 5
> /root/posix/tests/truncate/05.t               15    5  33.33%  5-6 10-12
> /root/posix/tests/truncate/12.t                3    1  33.33%  2
> /root/posix/tests/truncate/13.t                4    2  50.00%  2-3
> Failed 9/184 test scripts, 95.11% okay. 33/1950 subtests failed, 98.31% okay.
> 
> 
> btrfs:
> =====
> 
> Failed Test                     Stat Wstat Total Fail  Failed  List of Failed
> -------------------------------------------------------------------------------
> /root/posix/tests/chmod/00.t                  58    2   3.45%  3 19
> /root/posix/tests/chown/00.t                 171    4   2.34%  141 145 149 153
> /root/posix/tests/link/00.t                   82    8   9.76%  3 5-6 8-10 56 63
> /root/posix/tests/open/05.t                   12    2  16.67%  5 9
> /root/posix/tests/rename/00.t                 79    9  11.39%  3 6 8-9 11 13 37
>                                                                39 42
> /root/posix/tests/symlink/00.t                14    2  14.29%  2 5
> /root/posix/tests/truncate/00.t               21    1   4.76%  15
> /root/posix/tests/truncate/05.t               15    5  33.33%  5-6 10-12
> /root/posix/tests/truncate/12.t                3    1  33.33%  2
> /root/posix/tests/truncate/13.t                4    2  50.00%  2-3
> /root/posix/tests/unlink/00.t                 55    3   5.45%  17 22 53
> Failed 11/184 test scripts, 94.02% okay. 39/1950 subtests failed, 98.00% okay.
>
>
>

--
NTFS-3G:  http://ntfs-3g.org



-------------------------------------------------------------------------
This SF.net email is sponsored by the 2008 JavaOne(SM) Conference 
Register now and save $200. Hurry, offer ends at 11:59 p.m., 
Monday, April 7! Use priority code J8TLD2. 
http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.com/javaone
