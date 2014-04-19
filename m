From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH] generic: fix check for zero range support in generic/009
Date: Sat, 19 Apr 2014 17:41:49 -0400
Message-ID: <20140419214149.GA11494@thunk.org>
References: <20140419190524.GA2116@wallace>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-ext4@vger.kernel.org, xfs@oss.sgi.com
To: Eric Whitney <enwlinux@gmail.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <20140419190524.GA2116@wallace>
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

On Sat, Apr 19, 2014 at 03:05:24PM -0400, Eric Whitney wrote:
> Generic/001 fails when run on a file system that does not support byte range
> zeroing.  For example, an EOPNOTSUPP failure occurs when the test is run
> on a pre-3.15 extent-mapped file system.  The code in the test intended
> to prevent this contains an apparent typo that results in a check for
> fallocate() rather than zero range support.
> 
> Signed-off-by: Eric Whitney <enwlinux@gmail.com>

LGTM.

Reviewed-by: "Theodore Ts'o" <tytso@mit.edu>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
