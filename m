From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/18] ocfs2: use generic posix ACL infrastructure
Date: Tue, 3 Dec 2013 02:48:54 -0800
Message-ID: <20131203104854.GA3223@infradead.org>
References: <20131201115903.910559036@bombadil.infradead.org>
 <20131201120655.852590677@bombadil.infradead.org>
 <20131202230007.GK12253@quack.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: cluster-devel@redhat.com, xfs@oss.sgi.com, Mark Fasheh <mfasheh@suse.com>,
 reiserfs-devel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
 Christoph Hellwig <hch@infradead.org>, linux-mtd@lists.infradead.org,
 viro@zeniv.linux.org.uk, jfs-discussion@lists.sourceforge.net,
 linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-btrfs@vger.kernel.org,
 Joel Becker <jlbec@evilplan.org>
To: Jan Kara <jack@suse.cz>
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20131202230007.GK12253@quack.suse.cz>
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

On Tue, Dec 03, 2013 at 12:00:07AM +0100, Jan Kara wrote:
>   Hum, this changes the cluster locking. Previously ocfs2_acl_get() used
> from ocfs2_acl_chmod() grabbed cluster wide inode lock. Now getting of ACL
> isn't protected by the inode lock. That being said the cluster locking
> around setattr looks fishy anyway - if two processes on different
> nodes are changing attributes of the same file, changing ACLs post fact
> after dropping inode lock could cause interesting effects. Also I'm
> wondering how inode_change_ok() can ever be safe without holding inode
> lock... Until we grab that other node is free to change e.g. owner of the
> inode thus leading even to security implications. But maybe I'm missing
> something. Mark, Joel?

Hmm, indeed.  How does ocfs2_iop_get_acl get away without that lock?

Btw, ocfs2 changes will need careful testing as I couldn't find any easy
way to run xfstests on ocfs2 out of the box.


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
