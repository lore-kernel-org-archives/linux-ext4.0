From: David Sterba <dsterba@suse.cz>
Subject: Re: [RFC PATCH 1/5] new helper: iov_iter_rw()
Date: Tue, 17 Mar 2015 10:31:51 +0100
Message-ID: <20150317093151.GS20767@twin.jikos.cz>
References: <cover.1426502566.git.osandov@osandov.com>
 <34dc78b262546e9343e0ed872232a97f5eaa5f15.1426502566.git.osandov@osandov.com>
 <20150316173605.GX29656@ZenIV.linux.org.uk>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Omar Sandoval <osandov@osandov.com>, linux-fsdevel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org,
	linux-cifs@vger.kernel.org, osd-dev@open-osd.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	fuse-devel@lists.sourceforge.net, cluster-devel@redhat.com,
	jfs-discussion@lists.sourceforge.net, HPDD-discuss@ml01.01.org,
	linux-nfs@vger.kernel.org, linux-nilfs@vger.kernel.org,
	ocfs2-devel@oss.oracle.com, reiserfs-devel@vger.kernel.org,
	v9fs-developer@lists.sourceforge.net, xfs@oss.sgi.com,
	linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>,
	Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.cz>,
	Yan Zheng <zyan@redhat.com>, Sage Weil <sage@redhat.com>,
	Steve French <sfrench@samba.org>,
	Boaz Harrosh <ooo@electrozaur.com>,
	Benny Halevy <bhalevy@primarydata.com>,
	Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
	A
To: Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <linux-btrfs-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150316173605.GX29656@ZenIV.linux.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 16, 2015 at 05:36:05PM +0000, Al Viro wrote:
> On Mon, Mar 16, 2015 at 04:33:49AM -0700, Omar Sandoval wrote:
> > Get either READ or WRITE out of iter->type.
> 
> Umm...  
> 
> > + * Get one of READ or WRITE out of iter->type without any other flags OR'd in
> > + * with it.
> > + */
> > +static inline int iov_iter_rw(const struct iov_iter *i)
> > +{
> > +	return i->type & RW_MASK;
> > +}
> 
> TBH, I would turn that into a macro.  Reason: indirect includes.

Agreed, but the proposed define is rather cryptic and I was not able to
understand the meaning on the first glance.

> #define iov_iter_rw(i) ((0 ? (struct iov_iter *)0 : (i))->type & RW_MASK)

This worked for me, does not compile with anything else than
'struct iov_iter*' as i:

#define iov_iter_rw(i)	({			\
	struct iov_iter __iter = *(i);		\
	(i)->type & RW_MASK;			\
	})

The assignment is optimized out.
