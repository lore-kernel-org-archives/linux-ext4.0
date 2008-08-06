From: Thomas Trauner <tt@it-austria.net>
Subject: Re: duplicate entries on ext3 when using readdir/readdir64
Date: Wed, 06 Aug 2008 17:14:43 +0200
Message-ID: <1218035683.14552.61.camel@kannnix.a2x.lan.at>
References: <1217583820.12454.20.camel@kannnix.a2x.lan.at>
	<20080801121658.GG8736@mit.edu>
	<1217933631.14552.45.camel@kannnix.a2x.lan.at>
	<20080806140722.GA14109@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, ext3-users <ext3-users@redhat.com>
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <ext3-users-bounces@redhat.com>
In-Reply-To: <20080806140722.GA14109@mit.edu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/ext3-users>
List-Post: <mailto:ext3-users@redhat.com>
List-Help: <mailto:ext3-users-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/ext3-users>,
	<mailto:ext3-users-request@redhat.com?subject=subscribe>
Sender: ext3-users-bounces@redhat.com
Errors-To: ext3-users-bounces@redhat.com
List-Id: linux-ext4.vger.kernel.org

On Wed, 2008-08-06 at 10:07 -0400, Theodore Tso wrote:
> On Tue, Aug 05, 2008 at 12:53:51PM +0200, Thomas Trauner wrote:
> > On Fri, 2008-08-01 at 08:16 -0400, Theodore Tso wrote:
> > > On Fri, Aug 01, 2008 at 11:43:40AM +0200, Thomas Trauner wrote:
> > > > 
> > > > I have a problem with directories that contain more than 10000 entries
> > > > (Ubuntu 8.04.1) or with more than 70000 entries (RHEL 5.2). If you use
> > > > readdir(3) or readdir64(3) you get one entry twice, with same name and
> > > > inode.
> > > > 
> > I made new tests with the code under
> > <http://www.unet.univie.ac.at/~a9100884/readdir.c> on a bunch of freshly
> > generated and empty filesystems, every about 38GB large, of type fat
> > (aborted after about 22000 entries because it took to long), ext2, xfs,
> > jfs and again ext3....
> 
> OK, I have a workaroud for you.  It appears there's a kernel bug
> hiding here, since there shouldn't be duplicates returned by readdir()
> even if we have hash collisions.  

Thank you for your fast help and detailed explanation! Now I've
something to read at home ;)

Thanks!
Tom
