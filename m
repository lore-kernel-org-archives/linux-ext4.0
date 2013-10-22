From: Rich Johnston <rjohnston@sgi.com>
Subject: Re: [PATCH RESEND 4/7] xfsprogs: xfsio: add support
	FALLOC_FL_COLLAPSE_RANGE for fallocate
Date: Tue, 22 Oct 2013 10:21:33 -0500
Message-ID: <526697FD.1090406@sgi.com>
References: <1381090418-2829-1-git-send-email-linkinjeon@gmail.com>
	<52616EC6.7030400@sgi.com> <20131018224404.GX4446@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: Namjae Jeon <linkinjeon@gmail.com>, elder@kernel.org, tytso@mit.edu,
	Namjae Jeon <namjae.jeon@samsung.com>,
	linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@infradead.org,
	bpm@sgi.com, adilger.kernel@dilger.ca, viro@zeniv.linux.org.uk,
	a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org, mtk.manpages@gmail.com
To: Dave Chinner <david@fromorbit.com>
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <20131018224404.GX4446@dastard>
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

This commit was reverted

commit 19e73c9d220728617816c47a1671cc931c40e45b
Author: Rich Johnston <rjohnston@sgi.com>
Date:   Tue Oct 22 10:15:20 2013 -0500

     Revert "[RESEND, 4/7] xfsprogs: xfsio: add support 
FALLOC_FL_COLLAPSE_RANGE for fallocate"

     This reverts commit e64190f8440286a815060524777b435e06a7b364 until we
     have the fallocate API support merged into the kernel. The kernel
     code is still under review.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
