From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 05/18] fs: make posix_acl_chmod more useful
Date: Thu, 12 Dec 2013 13:05:02 -0800
Message-ID: <20131212210502.GB27686@infradead.org>
References: <20131211104243.148113893@bombadil.infradead.org>
 <20131211104527.223923019@bombadil.infradead.org>
 <389888733.69110.1386875240679.JavaMail.zimbra@linbit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: cluster-devel@redhat.com, xfs@oss.sgi.com, Jan Kara <jack@suse.cz>,
 Mark Fasheh <mfasheh@suse.com>, reiserfs-devel@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, Christoph Hellwig <hch@infradead.org>,
 linux-mtd@lists.infradead.org, viro@zeniv.linux.org.uk,
 jfs-discussion@lists.sourceforge.net, linux-fsdevel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org,
 linux-btrfs@vger.kernel.org, Joel Becker <jlbec@evilplan.org>
To: Andreas Gruenbacher <andreas.gruenbacher@linbit.com>
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <389888733.69110.1386875240679.JavaMail.zimbra@linbit.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
List-Id: linux-ext4.vger.kernel.org

On Thu, Dec 12, 2013 at 08:07:20PM +0100, Andreas Gruenbacher wrote:
> Christoph,
> 
> > +int
> > +posix_acl_chmod(struct inode *inode)
> > +{
> > +	struct posix_acl *acl;
> > +	int ret = 0;
> > +
> > +	if (S_ISLNK(inode->i_mode) || !inode->i_op->set_acl)
> > +		return -EOPNOTSUPP;
> 
> Symlinks never have get_acl callbacks, so I would remove the S_ISLNK() check here.

Yeah, will simplify it.  Same for the other places where we have both
checks.

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
