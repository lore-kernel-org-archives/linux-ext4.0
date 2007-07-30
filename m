From: Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [xfs-masters] [RFC: 2.6 patch] make the
	*FS_SECURITY options	no longer user visible
Date: Mon, 30 Jul 2007 08:27:47 -0400
Message-ID: <1185798467.15215.12.camel@moss-spartans.epoch.ncsc.mil>
References: <20070729150209.GS16817@stusta.de> <20070729232905.GG31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: jfs-discussion@lists.sourceforge.net, jmorris@namei.org,
	reiserfs-devel@vger.kernel.org, chrisw@sous-sol.org,
	xfs-masters@oss.sgi.com, linux-security-module@vger.kernel.org,
	jffs-dev@axis.com, eparis@parisplace.org, linux-ext4@vger.kernel.org
To: David Chinner <dgc@sgi.com>
Return-path: <jfs-discussion-bounces@lists.sourceforge.net>
In-Reply-To: <20070729232905.GG31489@sgi.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=jfs-discussion>
List-Post: <mailto:jfs-discussion@lists.sourceforge.net>
List-Help: <mailto:jfs-discussion-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/jfs-discussion>,
	<mailto:jfs-discussion-request@lists.sourceforge.net?subject=subscribe>
Sender: jfs-discussion-bounces@lists.sourceforge.net
Errors-To: jfs-discussion-bounces@lists.sourceforge.net
List-Id: linux-ext4.vger.kernel.org

On Mon, 2007-07-30 at 09:29 +1000, David Chinner wrote:
> On Sun, Jul 29, 2007 at 05:02:09PM +0200, Adrian Bunk wrote:
> > Please correct me if any of the following assumptions is wrong:
> > - SELinux is currently the only user of filesystem security labels
> >   shipped with the Linux kernel
> > - if a user has SELinux enabled he wants his filesystems to support
> >   security labels
> > 
> > Based on these assumption, it doesn't make sense to have the
> > *FS_SECURITY user visible since we can perfectly determine automatically 
> > when turning them on makes sense.
> 
> Hmmm. The code in XFS is not dependent on selinux, but this change
> would mean that testing the security xattr namespace would require a
> selinux enabled kernel.
> 
> I agree that the default for these should be "y" and selected if
> selinux is enabled, but forcing us to use selinux enabled kernels
> (on distro's that may not support selinux) just to test the
> security xattr namespace is a bit of a pain.

You can enable SECURITY_SELINUX in the kernel config but still have it
boot disabled by default via SECURITY_SELINUX_BOOTPARAM_VALUE=0.

-- 
Stephen Smalley
National Security Agency


-------------------------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc.
Still grepping through log files to find problems?  Stop.
Now Search log events and configuration files using AJAX and a browser.
Download your FREE copy of Splunk now >>  http://get.splunk.com/
