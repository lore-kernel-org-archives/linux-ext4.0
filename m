From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 02/18] fs: add get_acl helper
Date: Thu, 12 Dec 2013 13:04:39 -0800
Message-ID: <20131212210439.GA27686@infradead.org>
References: <20131211104243.148113893@bombadil.infradead.org>
 <20131211104526.648135334@bombadil.infradead.org>
 <1724169901.69108.1386875169382.JavaMail.zimbra@linbit.com>
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
In-Reply-To: <1724169901.69108.1386875169382.JavaMail.zimbra@linbit.com>
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

On Thu, Dec 12, 2013 at 08:06:09PM +0100, Andreas Gruenbacher wrote:
> > +	/*
> > +	 * A filesystem can force a ACL callback by just never filling the
> > +	 * ACL cache. But normally you'd fill the cache either at inode
> > +	 * instantiation time, or on the first ->get_acl call.
> > +	 *
> > +	 * If the filesystem doesn't have a get_acl() function at all, we'll
> > +	 * just create the negative cache entry.
> > +	 */
> > +	if (!inode->i_op->get_acl) {
> > +		set_cached_acl(inode, type, NULL);
> > +		return ERR_PTR(-EAGAIN);
> 
> The function should return NULL here.

Indeed.  EAGAIN is the convention check_acl() in fs/namei.c uses,
but it will return that automatically if we just return NULL here.

______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
