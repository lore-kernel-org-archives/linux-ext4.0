From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [RFC PATCH 1/5] new helper: iov_iter_rw()
Date: Tue, 17 Mar 2015 18:19:15 +0000
Message-ID: <20150317181910.GK29656@ZenIV.linux.org.uk>
References: <cover.1426502566.git.osandov@osandov.com>
 <34dc78b262546e9343e0ed872232a97f5eaa5f15.1426502566.git.osandov@osandov.com>
 <20150316173605.GX29656@ZenIV.linux.org.uk>
 <20150317093151.GS20767@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: dsterba-AlSwsSmVLrQ@public.gmane.org, Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>,
	linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	osd-dev-yNzVSZO3znNg9hUCZPvPmw@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, HPDD-discuss-y27Ovi1pjclAfugRpC6u6w@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>,
	Josef Bacik <jbacik-b10kYP2dOMg@public.gmane.org>, Yan Zheng <zyan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Sage Weil <sage-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Boaz Harrosh <ooo-rh7Tgz9RNieUD9Wbbkgo/g@public.gmane.org>,
	Benny Halevy <bhalevy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
	Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
	Andreas Dilger <
Return-path: <linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150317093151.GS20767-1ReQVI26iDCaZKY3DrU6dA@public.gmane.org>
Sender: linux-nilfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Tue, Mar 17, 2015 at 10:31:51AM +0100, David Sterba wrote:

> Agreed, but the proposed define is rather cryptic and I was not able to
> understand the meaning on the first glance.
> 
> > #define iov_iter_rw(i) ((0 ? (struct iov_iter *)0 : (i))->type & RW_MASK)
> 
> This worked for me, does not compile with anything else than
> 'struct iov_iter*' as i:
> 
> #define iov_iter_rw(i)	({			\
> 	struct iov_iter __iter = *(i);		\
> 	(i)->type & RW_MASK;			\
> 	})
> 
> The assignment is optimized out.

... and you are getting
	a) use of rather lousy gccism when plain C would do
	b) double evaluation since you've got it wrong (should've been
__iter.type & RW_MASK, if you do it that way).  As it is, if argument has
any side effects, your variant will trigger those twice - even if the
destination of the assignment is never used, the side effects remain.

I agree that it could use /* use ?: for typechecking */, but let's not go into
({...}) land unless we absolutely have to.
--
To unsubscribe from this list: send the line "unsubscribe linux-nilfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
