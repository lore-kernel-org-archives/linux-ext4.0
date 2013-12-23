From: "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 00/21] Consolidate Posix ACL implementation V3
Date: Mon, 23 Dec 2013 09:01:03 -0800
Message-ID: <20131223170103.GA14856@infradead.org>
References: <20131220131635.650823732@bombadil.infradead.org>
 <1387817904.8080.4.camel@ret.masoncoding.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "andreas.gruenbacher@linbit.com" <andreas.gruenbacher@linbit.com>,
 "jfs-discussion@lists.sourceforge.net"
 <jfs-discussion@lists.sourceforge.net>,
 "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
 "mfasheh@suse.com" <mfasheh@suse.com>,
 "reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>,
 "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "hch@infradead.org" <hch@infradead.org>,
 "cluster-devel@redhat.com" <cluster-devel@redhat.com>,
 "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
 "jlbec@evilplan.org" <jlbec@evilplan.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-f2fs-devel@lists.sourceforge.net"
 <linux-f2fs-devel@lists.sourceforge.net>,
 "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
 "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
 "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>
To: Chris Mason <clm@fb.com>
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1387817904.8080.4.camel@ret.masoncoding.com>
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

On Mon, Dec 23, 2013 at 04:57:58PM +0000, Chris Mason wrote:
> On Fri, 2013-12-20 at 05:16 -0800, Christoph Hellwig wrote:
> > This series consolidates the various cut'n'pasted Posix ACL implementations
> > into a single common one based on the ->get_acl method Linus added a while
> > ago and a new ->set_acl counterpart.
> > 
> > This remove ~1800 lines of code and provides a single place to implement
> > various nasty little gems of the semantics.
> 
> Is this in a git tree somewhere?

Only on my box.  Given how shitty kernel.org is to use these days I
don't bother with it anymore.


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
