From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: Re: [PATCH] xfstests: don't assume that falloc_punch implies falloc
	in test 255
Date: Thu, 7 Mar 2013 00:52:26 +0800
Message-ID: <20130306165226.GA3454@gmail.com>
References: <1362506382-26974-1-git-send-email-tytso@mit.edu>
	<51376A61.6060807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>,
	Theodore Ts'o <tytso@mit.edu>, xfs@oss.sgi.com
To: Eric Sandeen <sandeen@redhat.com>
Return-path: <xfs-bounces@oss.sgi.com>
Content-Disposition: inline
In-Reply-To: <51376A61.6060807@redhat.com>
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

On Wed, Mar 06, 2013 at 10:10:09AM -0600, Eric Sandeen wrote:
> On 3/5/13 11:59 AM, Theodore Ts'o wrote:
> > As of Linux 3.9-rc1, ext4 will support the punch operation on file
> > systems using indirect blocks, but it can not support the fallocate
> > operation (since there is no way to mark a block as uninitialized
> > using indirect block scheme).  This caused test 255 to fail, since it
> > only used _require_xfS_io_falloc_punch assuming that all file systems
> > which supported punch can also support fallocate.  Fix this.
> 
> Seems fine to avoid the incorrect failure, so as far as that goes:
> 
> Reviewed-by: Eric Sandeen <sandeen@redhat.com>
> 
> But we probably can & should still test punch in this situation,
> so we need a new test to exercise that I guess.

Hi Eric,

I have sent a patch set to add a test case for punching hole.  You can
find it in this link [1].  Sorry I don't finish the second version
according to Mark's comment.

1. http://www.spinics.net/lists/xfs/msg16234.html

Regards,
                                                - Zheng

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
