From: Szabolcs Szakacsits <szaka-IyvsvuGDJ8VAfugRpC6u6w@public.gmane.org>
Subject: Re: [ANNOUNCEMENT] Linux POSIX file system test
	suite
Date: Mon, 7 Apr 2008 02:51:15 +0300 (EEST)
Message-ID: <Pine.LNX.4.62.0804070234350.25240@tamago.serverit.net>
References: <Pine.LNX.4.62.0804022313390.664@tamago.serverit.net>
	<20080404003330.GW103491721@sgi.com>
	<20080404065109.GW108924158@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zfs-fuse-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org,
	ntfs-3g-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: David Chinner <dgc-sJ/iWh9BUns@public.gmane.org>
Return-path: <ntfs-3g-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <20080404065109.GW108924158-sJ/iWh9BUns@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/ntfs-3g-devel>,
	<mailto:ntfs-3g-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=ntfs-3g-devel>
List-Post: <mailto:ntfs-3g-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:ntfs-3g-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/ntfs-3g-devel>,
	<mailto:ntfs-3g-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Sender: ntfs-3g-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Errors-To: ntfs-3g-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-ext4.vger.kernel.org


On Fri, 4 Apr 2008, David Chinner wrote:
> On Fri, Apr 04, 2008 at 10:33:30AM +1000, David Chinner wrote:
> > On Thu, Apr 03, 2008 at 12:29:47AM +0300, Szabolcs Szakacsits wrote:
> > >   The test must be run as root user and requires a few basic Perl modules.
> > 
> > And openssl, it appears.

Openssl is replaced with md5sum+cut in the CVS. 

It would be also nice to eliminate the Perl dependency ...

> > The current xfs-dev tree:
> > 
> > Failed Test                    Stat Wstat Total Fail  Failed  List of Failed
> > -------------------------------------------------------------------------------
> > /root/posix/tests/chown/00.t                171    2   1.17%  84 88
> > /root/posix/tests/symlink/02.t                7    2  28.57%  6-7
> > Failed 2/184 test scripts, 98.91% okay. 4/1950 subtests failed, 99.79% okay.
> 
> Symlink tests 6 and 7:
> 
> expect 0 symlink ${name256} ${n0}
> expect 0 unlink ${n0}
> 
> Test 6 is failing with ENAMETOOLONG
> Test 7 is failing (correctly) with ENOENT because test 6 failed.
> 
> So there's only one failure here, and that is that that we're rejecting
> ${name256} as too long. I think that getname() is doing this. Seems sane
> to me to disallow symlinking to pathnames that can't be constructed,
> even if POSIX apparently allows it.

As Christoph noted, I also noticed XFS is unique in this behavior.

> Chown tests 84 and 88:
[...] 
> So, either result is valid. Hence i suggest that test 84 and test 88
> (same failure) are special cased to "ext3" behaviour.

Done in the CVS.

> That means XFS is not failing any tests at all.

I added the xfs target but left the symlink Test 6 fail because POSIX says

 "The string pointed to by path1 shall be treated only as a character 
  string and shall not be validated as a pathname" 

and 
 
 "the length of the path1 argument is longer than {SYMLINK_MAX}" 

where {SYMLINK_MAX} is typically not defined on Linux or it's {PATH_MAX}.

	Szaka

--
NTFS-3G:  http://ntfs-3g.org


-------------------------------------------------------------------------
This SF.net email is sponsored by the 2008 JavaOne(SM) Conference 
Register now and save $200. Hurry, offer ends at 11:59 p.m., 
Monday, April 7! Use priority code J8TLD2. 
http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.com/javaone
