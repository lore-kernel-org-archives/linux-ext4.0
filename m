From: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Subject: Re: [RFC PATCH 0/5] Remove rw parameter from direct_IO()
Date: Mon, 16 Mar 2015 18:15:21 +0000
Message-ID: <20150316181521.GY29656@ZenIV.linux.org.uk>
References: <cover.1426502566.git.osandov@osandov.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-btrfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	ceph-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	osd-dev-yNzVSZO3znNg9hUCZPvPmw@public.gmane.org, linux-ext4-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-f2fs-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org,
	fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cluster-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org,
	jfs-discussion-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, HPDD-discuss-y27Ovi1pjclAfugRpC6u6w@public.gmane.org,
	linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nilfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	ocfs2-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org, reiserfs-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	v9fs-developer-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, xfs-VZNHf3L845pBDgjK7y7TUQ@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>,
	Josef Bacik <jbacik-b10kYP2dOMg@public.gmane.org>, David Sterba <dsterba-AlSwsSmVLrQ@public.gmane.org>,
	Yan Zheng <zyan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sage Weil <sage-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>,
	Steve French <sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>,
	Boaz Harrosh <ooo-rh7Tgz9RNieUD9Wbbkgo/g@public.gmane.org>,
	Benny Halevy <bhalevy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>,
	Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>,
	Andreas Dilger <adilger.kernel@dilger.
To: Omar Sandoval <osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cover.1426502566.git.osandov-nWWhXC5lh1RBDgjK7y7TUQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-ext4.vger.kernel.org

On Mon, Mar 16, 2015 at 04:33:48AM -0700, Omar Sandoval wrote:
> Hi,
> 
> Al, here's some cleanup that you mentioned back in December that I got
> around to (https://lkml.org/lkml/2014/12/15/28).
> 
> In summary, the rw parameter to a_ops->direct_IO() is redundant with
> .type in struct iov_iter. Additionally, rw is inconsistently checked for
> being a WRITE; some filesystems do rw == WRITE, others do rw & WRITE,
> and others do both within the same function :) The distinction is that
> swapout may OR in the ITER_BVEC flag in the rw passed to ->direct_IO(),
> so the two are not equivalent (although this really only happens for
> swap-over-NFS, but it's scary nonetheless). After looking through all of
> these, it definitely looks like every check means for ANY write, not
> just non-kernel writes.
> 
> So, the solution presented here is:
> 
> - Add a helper, iov_iter_rw(), which always returns either READ or
>   WRITE, no ITER_.* or REQ_.* nonsense mixed in. For consistency, the
>   return value is always checked for equality

TBH, I'm not sure I like such calling conventions, but I guess we can
live with that.

> I decided to squish all of the filesystems together in patch 4 to avoid
> inundating the mailing lists with 20+ mostly two-line patches, but I can
> split those out if that's any better. Additionally, patch 1 pulls fs.h
> into uio.h, which seems undesirable.

... and easily avoided if you use a macro instead of inline, without losing
type safety or getting double evaluation, etc.

Look: 0 ? (struct T *)0 : (x) always evaluates to x.  Now look at 6.5.15p3 in
C99: the second and the third arguments are both pointers, so we are left with
p3.4 (both arguments are pointers to qualified or unqualified versions of
compatible types), p3.5 (one operand is a pointer and another null pointer
constant) and p3.6 (one operand is a pointer to an object or incomplete type,
and the other is a pointer to qualified or unqualied version of void.

The first variant means that x is a pointer to qualified or unqualified
struct T; the type of result is, per 6.5.15p6, the same as that of x.

The second variant means that x is a null pointer constant ((struct T *)0 isn't
one) and result is a null pointer to T.

The third one means that x is a pointer to qualified or unqualified void.
The type of result is the same as that of x.

Now note that your variant is no better wrt type safety; worse, actually, since
it does accept any pointer to void.  (0 ? (struct iov_iter *)0 : (x))->type
will reject those.  And we obviously don't have double evaluation here either.
