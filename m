From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] fs/vfs/security: pass last path component to LSM on
 inode creation
Date: Fri, 8 Jul 2011 17:17:22 +0100
Message-ID: <20110708161722.GG11013@ZenIV.linux.org.uk>
References: <20101208194527.13537.77202.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: xfs-masters@oss.sgi.com, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
	cluster-devel@redhat.com, linux-mtd@lists.infradead.org,
	jfs-discussion@lists.sourceforge.net, ocfs2-devel@oss.oracle.com,
	reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	jack@suse.cz, penguin-kernel@I-love.SAKURA.ne.jp, jeffm@suse.com,
	jmorris@namei.org, dhowells@redhat.com, adilger.kernel@dilger.ca,
	shaggy@linux.vnet.ibm.com, shemminger@vyatta.com, hch@lst.de,
	hughd@google.com, joel.becker@oracle.com, chris.mason@oracle.com,
	aelder@sgi.com, kees.cook@canonical.com, sds@tycho.nsa.gov,
	paul.moore@hp.com, mfasheh@suse.com, dchinner@redhat.com,
	eparis@parisplace.org, swhiteho@redhat.com, tao.ma@oracle.com,
	tytso@mit.edu, casey@schaufler-ca.com, serue@us.ibm.com,
	akpm@linux-foundation.org, dwmw2@infradea
To: Eric Paris <eparis@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20101208194527.13537.77202.stgit@paris.rdu.redhat.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Wed, Dec 08, 2010 at 02:45:27PM -0500, Eric Paris wrote:
> SELinux would like to implement a new labeling behavior of newly created
> inodes.  We currently label new inodes based on the parent and the creating
> process.  This new behavior would also take into account the name of the
> new object when deciding the new label.  This is not the (supposed) full path,
> just the last component of the path.
> 
> This is very useful because creating /etc/shadow is different than creating
> /etc/passwd but the kernel hooks are unable to differentiate these
> operations.  We currently require that userspace realize it is doing some
> difficult operation like that and than userspace jumps through SELinux hoops
> to get things set up correctly.  This patch does not implement new
> behavior, that is obviously contained in a seperate SELinux patch, but it
> does pass the needed name down to the correct LSM hook.  If no such name
> exists it is fine to pass NULL.

-ETOOFUCKINGUGLY...
