From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [RFC] directory quota survey on xfs
Date: Sun, 22 Dec 2013 17:59:29 +0800
Message-ID: <20131222095929.GA11444@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com, Ben Myers <bpm@sgi.com>,
	Dmitry Monakhov <dmonakhov@openvz.org>,
	Andreas Dilger <adilger.kernel@dilger.ca>
To: linux-ext4@vger.kernel.org
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
List-Id: linux-ext4.vger.kernel.org

Hi all,

As discussed with ext4 folks, I will try to make ext4 file system support
directory quota (a.k.a., project id in xfs).  For keeping consistency
with xfs's implementation, I did some tests on xfs, and I summarized the
result as following.  This will help us understand what we can do and
what we can't do.  Please correct me if I miss doing some tests or mis-
understand something.

I just do some tests about rename/hardlink because they are the key
issue from our discussion.

+ unaccounted dir
x accounted dir

rename(mv)
==========

+ -> +: ok

+ -> x: ok

I use strace(1) to lookup which syscall is used, and I found that xfs
will return EXDEV when mv(1) tries to use rename(2) to move a dir from
a unaccounted dir to a accounted dir.  Then mv uses creat(2)/read(2)/
write(2) syscalls to move this dir.

x -> +: wrong (design by feature?) 

If we move a dir from a accounted dir to a unaccounted dir, the quota is
still accounted.  It seems that xfs don't remove project id from this
dir and its subdirs/files on this case.

x -> x: ok

Xfs returns EXDEV error when mv(1) uses rename(2) to move a dir from a
accounted dir to another accounted dir (These dirs have different
project ids).  Then mv(1) uses creat(1)/read(1)/write(1) syscalls to
move this dir.

summary:
rename        +        x
+             ok       ok (EXDEV)
x             wrong    ok (EXDEV)

hardlink(ln)
========

+ -> +: ok

+ -> x: error

Xfs also returns EXDEV error to forbid this operation.  So that means
that we don't allow users to do a hardlink for a file from a unaccount
dir to a accounted dir.

x -> +: ok

This operation can be executed and no any error is reported.  After that
the quota doesn't be changed.  When both of two hardlinks are removed,
the quota will be discharged.

x -> x: error

Xfs returns EXDEV error to forbid this operation.

summary:
hardlink        +        x
+               ok       error (EXDEV)
x               ok       error (EXDEV)

As always, any comment or idea are welcome.

Thanks,
						- Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
